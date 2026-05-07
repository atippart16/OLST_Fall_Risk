-- =========================================================================
-- PROJECT: Multimodal Sensor Fusion for Balance Instability Classification
-- SOURCE FILE: OLST_Final_Merged.csv 
-- OUTPUT: OLST_Final_Cleaned.csv 
-- =========================================================================


-- =--- STEP 1: CREATING TABLE ---=
CREATE TABLE `OLST_Final_Cleaned` (
  OLST_attempt_id VARCHAR(50),
  RADAR_capture VARCHAR(50),
  MOCAP_Start_Time FLOAT,
  MOCAP_End_Time FLOAT,
  RADAR_Start_Frame INT,
  RADAR_End_Frame INT,
  Seconds_per_Frame FLOAT,
  an INT,
  is_attempt_final VARCHAR(10),
  t_foot_up FLOAT,
  t_stable FLOAT,
  t_break FLOAT,
  t_end FLOAT,
  frame_foot_up INT,
  frame_stable FLOAT,
  frame_break FLOAT,
  frame_end INT,
  participant_id INT,
  label VARCHAR(50),
  movement_code VARCHAR(50),
  stance_leg VARCHAR(5),
  lifted_leg VARCHAR(5),
  stance_knee_vel_mean FLOAT,
  stance_knee_vel_std FLOAT,
  stance_knee_vel_max FLOAT,
  lifted_knee_vel_mean FLOAT,
  lifted_knee_vel_std FLOAT,
  lifted_knee_vel_max FLOAT,
  stance_knee_acc_mean FLOAT,
  stance_knee_acc_std FLOAT,
  stance_knee_acc_max FLOAT,
  lifted_knee_acc_mean FLOAT,
  lifted_knee_acc_std FLOAT,
  lifted_knee_acc_max FLOAT,
  com_disp_mean FLOAT,
  com_disp_std FLOAT,
  com_disp_max FLOAT,
  com_range_x FLOAT,
  com_range_y FLOAT,
  com_vel_mean FLOAT,
  com_vel_std FLOAT,
  trunk_sway_x_std FLOAT,
  trunk_sway_y_std FLOAT,
  trunk_sway_x_range FLOAT,
  trunk_sway_y_range FLOAT,
  trunk_sway_vel_mean FLOAT,
  trunk_sway_vel_std FLOAT,
  doppler_centroid_mean FLOAT,
  doppler_centroid_std FLOAT,
  doppler_centroid_max FLOAT,
  doppler_centroid_range FLOAT,
  micro_vel_mean FLOAT,
  micro_vel_std FLOAT,
  micro_vel_max FLOAT,
  micro_vel_energy FLOAT,
  micro_acc_mean FLOAT,
  micro_acc_std FLOAT,
  micro_acc_max FLOAT,
  amp_total_power_mean FLOAT,
  amp_total_power_std FLOAT,
  amp_total_power_range FLOAT,
  amp_peak_power_mean FLOAT,
  amp_peak_power_std FLOAT,
  amp_variation_mean FLOAT,
  amp_variation_std FLOAT,
  amp_variation_max FLOAT,
  COP_AP_range_mm FLOAT,
  COP_AP_mean_mm FLOAT,
  COP_AP_sd_mm FLOAT,
  COP_ML_range_mm FLOAT,
  COP_ML_mean_mm FLOAT,
  COP_ML_sd_mm FLOAT,
  COP_speed_mean_mm_s FLOAT,
  COP_speed_sd_mm_s FLOAT,
  COP_speed_max_mm_s FLOAT,
  COP_speed_computed_mean FLOAT,
  GRF_Z_mean_N FLOAT,
  GRF_Z_sd_N FLOAT,
  GRF_Z_cv_pct FLOAT,
  GRF_Z_range_N FLOAT,
  sway_path_length_mm FLOAT,
  sway_path_per_second_mm_s FLOAT,
  trial_duration_s FLOAT
);

-- =--- STEP 2: DATA INSERTION ---=
-- Imported to phpMyAdmin using OLST_Final_Cleaned_import.sql
-- Source: OLST_Final_Merged.csv
-- Raw rows inserted: 1,241

-- Verify raw count before cleaning:
SELECT COUNT(*) FROM `OLST_Final_Cleaned`;
-- Expected: 1241


-- =--- STEP 3: CLEANING ---=
-- Removes 17 rows with hardware/sensor failures (missing sensor readings).
-- Note: t_break and frame_break are intentionally excluded --
--       NULL in those columns means the participant did NOT lose balance (valid data).

DELETE FROM `OLST_Final_Cleaned`
WHERE
    `OLST_attempt_id` = 'OLST_attempt_id'

    -- MOCAP: Kinematic sensors (12 affected rows)
    OR `stance_knee_vel_mean` IS NULL
    OR `stance_knee_vel_std` IS NULL
    OR `stance_knee_vel_max` IS NULL
    OR `lifted_knee_vel_mean` IS NULL
    OR `lifted_knee_vel_std` IS NULL
    OR `lifted_knee_vel_max` IS NULL
    OR `stance_knee_acc_mean` IS NULL
    OR `stance_knee_acc_std` IS NULL
    OR `stance_knee_acc_max` IS NULL
    OR `lifted_knee_acc_mean` IS NULL
    OR `lifted_knee_acc_std` IS NULL
    OR `lifted_knee_acc_max` IS NULL

    -- MOCAP: COM / Trunk (same 12 rows)
    OR `com_disp_mean` IS NULL
    OR `com_disp_std` IS NULL
    OR `com_disp_max` IS NULL
    OR `com_range_x` IS NULL
    OR `com_range_y` IS NULL
    OR `com_vel_mean` IS NULL
    OR `com_vel_std` IS NULL
    OR `trunk_sway_x_std` IS NULL
    OR `trunk_sway_y_std` IS NULL
    OR `trunk_sway_x_range` IS NULL
    OR `trunk_sway_y_range` IS NULL
    OR `trunk_sway_vel_mean` IS NULL
    OR `trunk_sway_vel_std` IS NULL

    -- RADAR: Micro-Doppler (6 affected rows)
    OR `doppler_centroid_mean` IS NULL
    OR `doppler_centroid_std` IS NULL
    OR `doppler_centroid_max` IS NULL
    OR `doppler_centroid_range` IS NULL
    OR `micro_vel_mean` IS NULL
    OR `micro_vel_std` IS NULL
    OR `micro_vel_max` IS NULL
    OR `micro_vel_energy` IS NULL
    OR `micro_acc_mean` IS NULL
    OR `micro_acc_std` IS NULL
    OR `micro_acc_max` IS NULL
    OR `amp_total_power_mean` IS NULL
    OR `amp_total_power_std` IS NULL
    OR `amp_total_power_range` IS NULL
    OR `amp_peak_power_mean` IS NULL
    OR `amp_peak_power_std` IS NULL
    OR `amp_variation_mean` IS NULL
    OR `amp_variation_std` IS NULL
    OR `amp_variation_max` IS NULL

    -- FORCE PLATE: COP & GRF (5 affected rows)
    OR `COP_AP_range_mm` IS NULL
    OR `COP_AP_mean_mm` IS NULL
    OR `COP_AP_sd_mm` IS NULL
    OR `COP_ML_range_mm` IS NULL
    OR `COP_ML_mean_mm` IS NULL
    OR `COP_ML_sd_mm` IS NULL
    OR `COP_speed_mean_mm_s` IS NULL
    OR `COP_speed_sd_mm_s` IS NULL
    OR `COP_speed_max_mm_s` IS NULL
    OR `COP_speed_computed_mean` IS NULL
    OR `GRF_Z_mean_N` IS NULL
    OR `GRF_Z_sd_N` IS NULL
    OR `GRF_Z_cv_pct` IS NULL
    OR `GRF_Z_range_N` IS NULL
    OR `sway_path_length_mm` IS NULL
    OR `sway_path_per_second_mm_s` IS NULL;


-- Verify the final Dataset count is 1,224.
SELECT COUNT(*) FROM `OLST_Final_Cleaned`;
-- Expected: 1224

-- =--- STEP 4: EXPORT ---=
-- Export via phpMyAdmin: Export tab > Format: CSV > Go
-- Rename downloaded file to: OLST_Final_Cleaned.csv
