# Data Quality Audit Tool (Python/Pandas)

## Objective
Build a rule-based validation script to audit passenger data for logical inconsistencies, missing values, and formatting errors. Mimics real-world data quality assurance workflows for AI training datasets.

## Methodology
- **Dataset:** 714 records (Titanic Passenger Manifest)
- **Tooling:** Python, Pandas, NumPy
- **Validation Rules Applied:**
  1. Age range constraints (0-120)
  2. Fare non-negative check
  3. Logical consistency (Fare=0 vs. Paying Class)
  4. Family count validation (SibSp/Parch ≥ 0)
  5. Name field integrity (No blank strings)

## Results
- **Total Records Audited:** 714
- **Errors Flagged:** 7 records (1.0% of dataset)
- **Key Finding:** All 7 flagged records were single male passengers with $0 fare in paying classes (1st & 3rd), suggesting systematic data entry error or misclassified crew.

## Deliverables
- `data_audit.py`: Validation script
- `error_report.csv`: Exported rows requiring human review
