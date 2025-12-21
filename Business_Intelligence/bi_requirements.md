# Business Intelligence Requirements - SecureRehab

## Purpose

Transform prison data into insights to:

1. Reduce prison overcrowding
2. Improve rehabilitation success
3. Make better early-release decisions
4. Monitor offender risk levels

## Target Users

| User              | Needs                   | Dashboard Type                 |
| ----------------- | ----------------------- | ------------------------------ |
| **Prison Warden** | Monitor security risks  | Real-time alerts dashboard     |
| **Parole Board**  | Decide early releases   | Eligibility analysis dashboard |
| **Rehab Staff**   | Track program success   | Program performance dashboard  |
| **Government**    | Overcrowding statistics | Capacity management dashboard  |

## Data Sources

1. **offenders** - Risk scores, personal info
2. **offenses** - Criminal history, severity
3. **program_participation** - Rehabilitation progress
4. **sentences** - Time served, remaining time
5. **alerts** - Security incidents, warnings

## Reporting Frequency

- **Daily:** Risk score updates, new alerts
- **Weekly:** Program enrollment status
- **Monthly:** Early release eligibility review
- **Quarterly:** Recidivism rate analysis
- **Annual:** Overcrowding trend reports

## Technical Requirements

1. **Oracle Database** - PL/SQL for data processing
2. **Views** - Pre-calculated metrics
3. **Scheduled Jobs** - Automatic report generation
4. **Export to CSV** - For external analysis
