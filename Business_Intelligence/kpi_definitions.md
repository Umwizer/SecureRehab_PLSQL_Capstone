# Key Performance Indicators (KPIs) - SecureRehab

## Safety & Security KPIs

| KPI                     | Formula                               | Target     | Why It Matters                 |
| ----------------------- | ------------------------------------- | ---------- | ------------------------------ |
| **High-Risk Ratio**     | (High-risk offenders ÷ Total) × 100   | < 20%      | Monitor security threat level  |
| **Alert Response Time** | Average hours to address alerts       | < 24 hours | Ensure quick action on threats |
| **Incident Rate**       | Incidents per 100 offenders per month | < 5        | Measure prison safety          |

## Rehabilitation KPIs

| KPI                    | Formula                         | Target | Why It Matters                |
| ---------------------- | ------------------------------- | ------ | ----------------------------- |
| **Program Completion** | (Completed ÷ Enrolled) × 100    | > 70%  | Measure program effectiveness |
| **Recidivism Rate**    | (Re-offenders ÷ Released) × 100 | < 30%  | Long-term success indicator   |
| **Skill Acquisition**  | Offenders with certified skills | > 50%  | Employment readiness          |

## Efficiency KPIs

| KPI                     | Formula                                 | Target   | Why It Matters                  |
| ----------------------- | --------------------------------------- | -------- | ------------------------------- |
| **Early Release Rate**  | (Early releases ÷ Total releases) × 100 | > 15%    | Reduce overcrowding effectively |
| **Program Utilization** | (Enrolled ÷ Capacity) × 100             | 80-90%   | Optimal resource usage          |
| **Assessment Time**     | Days from intake to risk assessment     | < 7 days | Quick processing                |

## Capacity KPIs

| KPI                    | Formula                            | Target | Why It Matters                 |
| ---------------------- | ---------------------------------- | ------ | ------------------------------ |
| **Overcrowding Index** | (Population ÷ Capacity) × 100      | < 100% | Prevent overcrowding           |
| **Bed Occupancy**      | (Occupied beds ÷ Total beds) × 100 | 85-95% | Optimal facility usage         |
| **Turnover Rate**      | (Releases ÷ Avg population) × 100  | > 10%  | Healthy prison population flow |

## Sample Calculations

```sql
-- High-Risk Ratio Calculation
SELECT ROUND(
    (SELECT COUNT(*) FROM offenders WHERE risk_score > 0.7) * 100.0 /
    (SELECT COUNT(*) FROM offenders WHERE status = 'ACTIVE'),
    1
) as high_risk_percentage FROM dual;

-- Program Completion Rate
SELECT
    program_name,
    ROUND(
        completed_count * 100.0 / total_participants,
        1
    ) as completion_rate
FROM program_stats_view;
```
