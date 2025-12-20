# Phase VI - PL/SQL Development: 02_Functions

## Functions Created

### 1. `calculate_risk_score`

**Purpose:** Calculates a risk score (0-1) for an offender based on:

- Number of offenses
- Rehabilitation program completion rate
- Behavior history

**Parameters:** `p_offender_id IN NUMBER`
**Returns:** `NUMBER` (risk score between 0 and 1)

### 2. `check_early_release_eligibility`

**Purpose:** Determines if an offender is eligible for early release based on:

- Risk score
- Sentence completion percentage
- Rehabilitation program completions

**Parameters:** `p_offender_id IN NUMBER`
**Returns:** `VARCHAR2` (HIGHLY_ELIGIBLE, ELIGIBLE, CONDITIONAL, NOT_ELIGIBLE)

### 3. `get_program_availability`

**Purpose:** Checks availability status of a rehabilitation program

**Parameters:** `p_program_id IN NUMBER`
**Returns:** `VARCHAR2` (FULL, LIMITED, MODERATE, AVAILABLE, PROGRAM_NOT_FOUND)

### 4. `calculate_offender_age`

**Purpose:** Calculates offender's current age

**Parameters:** `p_offender_id IN NUMBER`
**Returns:** `NUMBER` (age in years)

### 5. `validate_offender_status`

**Purpose:** Validates if offender has required status

**Parameters:**

- `p_offender_id IN NUMBER`
- `p_required_status IN VARCHAR2 DEFAULT 'ACTIVE'`
  **Returns:** `BOOLEAN` (TRUE if status matches, FALSE otherwise)

## Testing

Run `test_functions.sql` to verify all functions work correctly.
