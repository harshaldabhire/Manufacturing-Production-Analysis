import random
from datetime import datetime, timedelta

import numpy as np
import pandas as pd


def generate_dates(start_date: str, end_date: str, size: int) -> pd.Series:
    """Generate a random series of dates between two dates (inclusive)."""
    start = datetime.fromisoformat(start_date)
    end = datetime.fromisoformat(end_date)
    total_days = (end - start).days + 1
    random_days = np.random.randint(0, total_days, size=size)
    return pd.to_datetime([start + timedelta(days=int(day)) for day in random_days]).date


def choose_line_downtime(line: str) -> float:
    """Return a realistic downtime value based on production line characteristics."""
    if line == "Rolling Line":
        return np.random.normal(loc=80, scale=35)
    if line == "Finishing Line":
        return np.random.normal(loc=20, scale=12)
    if line == "Slitting Line":
        return np.random.normal(loc=45, scale=20)
    if line == "Pickling Line":
        return np.random.normal(loc=50, scale=22)
    if line == "Cut-to-Length Line":
        return np.random.normal(loc=60, scale=25)
    return np.random.normal(loc=50, scale=20)


def choose_product_scrap_rate(product: str) -> float:
    """Return a scrap rate depending on product type."""
    base_rates = {
        "Steel Plate": (0.04, 0.015),
        "Steel Strip": (0.035, 0.012),
        "GI Sheet": (0.03, 0.01),
        "HR Sheet": (0.028, 0.01),
        "CR Sheet": (0.025, 0.009),
        "HR Coil": (0.02, 0.008),
        "CR Coil": (0.015, 0.006),
        "GP Coil": (0.018, 0.007),
    }
    loc, scale = base_rates.get(product, (0.02, 0.01))
    return np.clip(np.random.normal(loc=loc, scale=scale), 0.005, 0.06)


def choose_shift_efficiency(shift: str) -> float:
    """Return an efficiency percentage based on the shift."""
    if shift == "A":
        return np.random.normal(loc=96.5, scale=1.8)
    if shift == "B":
        return np.random.normal(loc=94.5, scale=2.2)
    if shift == "C":
        return np.random.normal(loc=92.5, scale=2.8)
    return np.random.normal(loc=94, scale=2.5)


def add_text_noise(value: str) -> str:
    """Add random leading or trailing whitespace to a text value."""
    prefix = " " if random.choice([True, False]) else ""
    suffix = " " if random.choice([True, False]) else ""
    return f"{prefix}{value}{suffix}"


def build_dataset(record_count: int = 20_000) -> pd.DataFrame:
    """Build the clean manufacturing production dataset."""
    random.seed(42)
    np.random.seed(42)

    lines = [
        "Rolling Line",
        "Slitting Line",
        "Pickling Line",
        "Cut-to-Length Line",
        "Finishing Line",
    ]
    products = [
        "CR Coil",
        "HR Coil",
        "GP Coil",
        "GI Sheet",
        "Steel Plate",
        "Steel Strip",
        "CR Sheet",
        "HR Sheet",
    ]
    machines = [f"MC{idx:03d}" for idx in range(1, 21)]
    operators = [f"OP{idx:03d}" for idx in range(1, 31)]
    shifts = ["A", "B", "C"]
    downtime_reasons = [
        "Mechanical Failure",
        "Power Failure",
        "Tool Change",
        "Material Shortage",
        "Quality Inspection",
        "Scheduled Maintenance",
    ]

    production_ids = [f"PRD{idx:05d}" for idx in range(1, record_count + 1)]
    dates = generate_dates("2025-01-01", "2025-12-31", record_count)
    production_lines = np.random.choice(lines, size=record_count, p=[0.22, 0.20, 0.18, 0.20, 0.20])
    shifts_choice = np.random.choice(shifts, size=record_count, p=[0.35, 0.33, 0.32])
    machines_choice = np.random.choice(machines, size=record_count)
    operators_choice = np.random.choice(operators, size=record_count)
    products_choice = np.random.choice(products, size=record_count)
    planned_qty = np.random.randint(500, 2_501, size=record_count)

    downtime_values = [
        np.clip(choose_line_downtime(line), 0, 180)
        for line in production_lines
    ]
    downtime_minutes = np.round(downtime_values).astype(int)
    downtime_reason = np.random.choice(downtime_reasons, size=record_count, p=[0.24, 0.12, 0.18, 0.16, 0.18, 0.12])

    scrap_rates = [choose_product_scrap_rate(product) for product in products_choice]
    scrap_qty = np.maximum(np.round(planned_qty * scrap_rates).astype(int), 0)
    scrap_qty = np.minimum(scrap_qty, planned_qty // 4)

    produced_qty = planned_qty - scrap_qty
    efficiency_values = [
        np.clip(np.random.normal(loc=choose_shift_efficiency(shift), scale=0.8), 85.0, 99.0)
        for shift in shifts_choice
    ]
    efficiency_percent = np.round(efficiency_values, 1)

    scrap_rate_percent = np.round(np.where(planned_qty > 0, scrap_qty / planned_qty * 100, 0.0), 2)

    dataset = pd.DataFrame(
        {
            "Production_ID": production_ids,
            "Date": dates,
            "Production_Line": production_lines,
            "Shift": shifts_choice,
            "Machine_ID": machines_choice,
            "Operator_ID": operators_choice,
            "Product": products_choice,
            "Planned_Qty": planned_qty,
            "Produced_Qty": produced_qty,
            "Scrap_Qty": scrap_qty,
            "Downtime_Minutes": downtime_minutes,
            "Downtime_Reason": downtime_reason,
            "Efficiency_Percent": efficiency_percent,
            "Scrap_Rate_Percent": scrap_rate_percent,
        }
    )

    return dataset


def inject_data_quality_issues(df: pd.DataFrame) -> pd.DataFrame:
    """Introduce controlled data quality issues into the dataset."""
    df = df.copy()
    record_count = len(df)

    # 30 duplicate rows by replacing random records with copies of other rows
    source_pool = df.index[: record_count // 2]
    target_pool = df.index[record_count // 2 :]
    duplicate_source_idx = np.random.choice(source_pool, size=30, replace=False)
    duplicate_target_idx = np.random.choice(target_pool, size=30, replace=False)
    for target_idx, source_idx in zip(duplicate_target_idx, duplicate_source_idx):
        df.loc[target_idx] = df.loc[source_idx]

    # 150 missing Operator_ID values
    missing_operator_idx = np.random.choice(df.index, size=150, replace=False)
    df.loc[missing_operator_idx, "Operator_ID"] = pd.NA

    # 100 product names with inconsistent capitalization
    inconsistent_idx = np.random.choice(df.index, size=100, replace=False)
    for idx in inconsistent_idx:
        original = df.at[idx, "Product"]
        variants = [original.lower(), original.upper(), original.title(), original.swapcase()]
        df.at[idx, "Product"] = random.choice(variants)

    # 100 text values with leading or trailing spaces across text columns
    text_columns = ["Production_Line", "Shift", "Machine_ID", "Operator_ID", "Product", "Downtime_Reason"]
    for _ in range(100):
        row = random.choice(df.index)
        col = random.choice(text_columns)
        value = df.at[row, col]
        if pd.isna(value):
            continue
        df.at[row, col] = add_text_noise(str(value))

    # 5 negative Produced_Qty values to simulate data-entry errors
    negative_idx = np.random.choice(df.index, size=5, replace=False)
    df.loc[negative_idx, "Produced_Qty"] = -np.abs(np.random.randint(1, 50, size=5))

    return df


def main() -> None:
    """Generate the synthetic manufacturing dataset and export it to CSV."""
    dataset = build_dataset(record_count=20_000)
    dataset_with_issues = inject_data_quality_issues(dataset)
    dataset_with_issues.to_csv("manufacturing_data.csv", index=False)

    print("First five rows of the generated dataset:")
    print(dataset_with_issues.head(5).to_string(index=False))
    print()
    print(f"Dataset shape: {dataset_with_issues.shape}")
    print(f"Missing values count:\n{dataset_with_issues.isna().sum()}\n")
    print(f"Duplicate rows count: {dataset_with_issues.duplicated().sum()}")
    print("manufacturing_data.csv has been created successfully.")


if __name__ == "__main__":
    main()
