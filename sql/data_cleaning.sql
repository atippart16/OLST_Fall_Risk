-- =========================================================================
-- PROJECT: Multimodal Sensor Fusion for Balance Instability Assessment
-- TARGET: 1,224-row(verified manually in excel) cleaned dataset (from 1,241 raw records)
-- =========================================================================

-- PHASE 1: Table creation
CREATE TABLE IF NOT EXISTS `postural_analysis` (
    -- METADATA & EXPERIMENT IDENTIFIERS
    `OLST_attempt_id` VARCHAR(255) NOT NULL,
    `RADAR_capture` VARCHAR(255),
    `MOCAP_Start_Time` FLOAT,
    `MOCAP_End_Time` FLOAT,
    `RADAR_Start_Frame` INT,
    `RADAR_End_Frame` INT,
    `Seconds_per_Frame` FLOAT,
    `an` INT,
    `is_attempt_final` VARCHAR(10),
    `participant_id` INT,
    `label` VARCHAR(50), -- Target Class: STABLE / UNSTABLE
    `movement_code` VARCHAR(50),
    `stance_leg` VARCHAR(10),
    `lifted_leg` VARCHAR(10),

    -- TEMPORAL & EVENT MARKERS
    `t_foot_up` FLOAT,
    `t_stable` FLOAT,
    `t_break` FLOAT,
    `t_end` FLOAT,
    `frame_foot_up` INT,
    `frame_stable` INT,
    `frame_break` INT,
    `frame_end` INT,

    -- MOCAP MODALITY: KNEE & CENTER OF MASS (COM)
    `stance_knee_vel_mean` FLOAT, `stance_knee_vel_std` FLOAT, `stance_knee_vel_max` FLOAT,
    `lifted_knee_vel_mean` FLOAT, `lifted_knee_vel_std` FLOAT, `lifted_knee_vel_max` FLOAT,
    `stance_knee_acc_mean` FLOAT, `stance_knee_acc_std` FLOAT, `stance_knee_acc_max` FLOAT,
    `lifted_knee_acc_mean` FLOAT, `lifted_knee_acc_std` FLOAT, `lifted_knee_acc_max` FLOAT,
    `com_disp_mean` FLOAT, `com_disp_std` FLOAT, `com_disp_max` FLOAT,
    `com_range_x` FLOAT, `com_range_y` FLOAT, `com_vel_mean` FLOAT, `com_vel_std` FLOAT,

    -- MOCAP MODALITY: TRUNK SWAY
    `trunk_sway_x_std` FLOAT, `trunk_sway_y_std` FLOAT, `trunk_sway_x_range` FLOAT,
    `trunk_sway_y_range` FLOAT, `trunk_sway_vel_mean` FLOAT, `trunk_sway_vel_std` FLOAT,

    -- RADAR MODALITY: MICRO-DOPPLER TELEMETRY
    `doppler_centroid_mean` FLOAT, `doppler_centroid_std` FLOAT, `doppler_centroid_max` FLOAT,
    `doppler_centroid_range` FLOAT, `micro_vel_mean` FLOAT, `micro_vel_std` FLOAT,
    `micro_vel_max` FLOAT, `micro_vel_energy` FLOAT, `micro_acc_mean` FLOAT,
    `micro_acc_std` FLOAT, `micro_acc_max` FLOAT,
    `amp_total_power_mean` FLOAT, `amp_total_power_std` FLOAT, `amp_total_power_range` FLOAT,
    `amp_peak_power_mean` FLOAT, `amp_peak_power_std` FLOAT,
    `amp_variation_mean` FLOAT, `amp_variation_std` FLOAT, `amp_variation_max` FLOAT,

    -- FORCE PLATE MODALITY: CENTER OF PRESSURE (COP)
    `COP_AP_range_mm` FLOAT, `COP_AP_mean_mm` FLOAT, `COP_AP_sd_mm` FLOAT,
    `COP_ML_range_mm` FLOAT, `COP_ML_mean_mm` FLOAT, `COP_ML_sd_mm` FLOAT,
    `COP_speed_mean_mm_s` FLOAT, `COP_speed_sd_mm_s` FLOAT, `COP_speed_max_mm_s` FLOAT,
    `COP_speed_computed_mean` FLOAT,

    -- FORCE PLATE MODALITY: GROUND REACTION FORCE (GRF)
    `GRF_Z_mean_N` FLOAT, `GRF_Z_sd_N` FLOAT, `GRF_Z_cv_pct` FLOAT, `GRF_Z_range_N` FLOAT,
    `sway_path_length_mm` FLOAT, `sway_path_per_second_mm_s` FLOAT,
    `trial_duration_s` FLOAT,

    PRIMARY KEY (`OLST_attempt_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- =--- PHASE 2: Table cleaning ---=
-- Purges the 18 invalid records (17 hardware failures + 1 middle header).
DELETE FROM `postural_analysis`
WHERE 
    `OLST_attempt_id` = 'OLST_attempt_id'
    OR TRIM(CAST(`COP_AP_range_mm` AS CHAR)) IN ('', 'nan', 'NaN')
    OR TRIM(CAST(`stance_knee_vel_mean` AS CHAR)) IN ('', 'nan', 'NaN')
    OR `COP_AP_range_mm` IS NULL;

-- =--- PHASE 3: t_stable logic ---=
-- Normalizing stability markers for 'UNSTABLE' trials.
UPDATE `postural_analysis`
SET `t_stable` = NULL
WHERE `label` = 'UNSTABLE';

-- =--- PHASE 4: REPRODUCIBILITY ---=
-- Verify the Dataset count is 1,224.
SELECT COUNT(*) AS total_golden_records FROM `postural_analysis`;