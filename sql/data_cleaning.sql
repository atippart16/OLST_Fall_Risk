-- =========================================================================
-- PROJECT: Human Postural Stability Analysis (Sensor Fusion)
-- PURPOSE: Data Engineering Pipeline (Raw Ingestion to Golden Dataset)
-- TARGET COHORT: 1,224 Cleaned Trials (1,073 Stable / 151 Unstable)
-- =========================================================================

-- PHASE 1: Schema Definition
-- Defining a robust 60+ variable schema for MOCAP, Radar, and Force Plate data.
CREATE TABLE IF NOT EXISTS `postural_analysis` (
    `OLST_attempt_id` VARCHAR(255) NOT NULL,
    `RADAR_capture` VARCHAR(255),
    `participant_id` VARCHAR(50),
    `label` VARCHAR(50), -- Binary Target: 'STABLE' vs 'UNSTABLE'
    
    -- Force Plate Features (Example Anchor)
    `COP_AP_range_mm` FLOAT,
    `sway_path_length_mm` FLOAT,
    
    -- MOCAP Features (Example Anchor)
    `stance_knee_vel_mean` FLOAT,
    `trunk_sway_vel_mean` FLOAT,
    
    -- Radar Features (Example Anchor)
    `doppler_centroid_mean` FLOAT,
    `micro_vel_mean` FLOAT,
    
    -- Metadata and Timing
    `t_stable` FLOAT,
    `t_break` FLOAT,
    
    PRIMARY KEY (`OLST_attempt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- PHASE 2: Data Ingestion Note
-- [NOTE: At this stage, data is typically imported from an external CSV.]
-- The raw import initially results in 1,242 records (including 17 glitches and 1 header).

-- PHASE 3: Surgical Cleaning & Artifact Removal
-- Targeted deletion of 18 invalid records to establish the 1,224-row Golden Dataset.
DELETE FROM `postural_analysis`
WHERE 
    -- 1. Identify 17 Hardware-Sync Glitches (using Type-Cast to find 'nan' and spaces)
    TRIM(CAST(`COP_AP_range_mm` AS CHAR)) IN ('', 'nan', 'NaN') OR 
    TRIM(CAST(`stance_knee_vel_mean` AS CHAR)) IN ('', 'nan', 'NaN') OR 
    TRIM(CAST(`doppler_centroid_mean` AS CHAR)) IN ('', 'nan', 'NaN') OR
    
    -- 2. Handle NULL entries across all sensor modalities
    `COP_AP_range_mm` IS NULL OR
    `stance_knee_vel_mean` IS NULL OR
    `doppler_centroid_mean` IS NULL OR

    -- 3. Purge the redundant middle-row CSV header
    `OLST_attempt_id` = 'OLST_attempt_id';

-- PHASE 4: Biomechanical Logic Normalization
-- Ensuring 'UNSTABLE' trials (failures) do not have misleading stability timestamps.
UPDATE `postural_analysis`
SET `t_stable` = NULL
WHERE `label` = 'UNSTABLE';

-- PHASE 5: Post-Purge Validation
-- Final count check: Expected 1,224.
SELECT COUNT(*) AS final_golden_count FROM `postural_analysis`;