# AUSRA Thesis — Working Context & Progress

This file is auto-loaded by the Antigravity Agent when a session starts in this directory.
It captures the thesis restructure plan, decisions made, and where we stopped so
work can resume seamlessly.

## Antigravity Workflow Rules
- **Artifacts:** When generating an `implementation_plan.md`, always include a list of the `.tex` files that will be modified and when you try to edit multiple files, edit sequentially.


## Project summary
- **AUSRA** (Autonomous Unified Swarm Robotics Architecture): graduation thesis,
   Ain Shams University, Mechatronics. A cost-effective (~$420/unit) swarm of
  three-wheel **omnidirectional** robots for collaborative 2D mapping, autonomous
  exploration, and victim localization (SAR/disaster scenarios).
- Stack: ROS 2 Humble, Nav2, slam_toolbox, EKF (robot_localization), frontier
  exploration (explore_lite on HW), micro-ROS on ESP32-S3, Jetson Orin Nano.
- Semester 1 = design + simulation. Semester 2 = sim-to-real hardware bring-up,
  tuning, single-robot autonomy, and multi-robot swarm + map merging.

## Thesis location & build
- Root: `/home/gharably/sirius_swarm_ws/src/AUSRA_Thesis/`
- Main file: `main.tex` (mitthesis class, biber, custom ASU styling).
- Build: `latexmk -pdf main.tex` (or pdflatex → biber → pdflatex ×2).
- PDF output: `pdf/main.pdf`.
- Related ROS packages live in sibling folders under
  `/home/gharably/sirius_swarm_ws/src/` (NOT inside AUSRA_Thesis):
  - `Omni-Directional-Driver/` — omni driver (cmd_vel→wheels, encoders→odom)
  - `low-level/Tuned_with_Commnunication/` — tuned ESP32 firmware (PID + ramp)
  - `AUSRA-Autonomous-System/lidar_slam_pkg/` — Nav2 + SLAM + explore configs/launch
  - `AUSRA-Autonomous-System/Localization/ausra_localization/` — EKF + IMU configs
  - `AUSRA-Autonomous-System/ausra_map_merge_HW/` — multi-robot map merging
  - `AUSRA-Autonomous-System/ausra_numpad_teleop/` — keyboard teleop
  - `ausrabot_description/` — URDF/xacro, hardware_params.yaml

## NEW thesis structure (10 chapters) — DECIDED
Part I = design/simulation; Part II = implementation/hardware/swarm.

1. Introduction — **DONE (rewritten this session)**
2. Literature Review — minor adds pending (explore_lite, map merging, MR-SLAM, perception)
3. Mechanical Design & Structural Analysis — mostly unchanged
4. Electrical System & Embedded Design — corrections pending (baud, loop rate, CPR;
   add ramp-input + CPR-correction subsections; namespace firmware)
5. Autonomous Navigation Stack: Architecture & Simulation — retitled; keep sim work
6. **(NEW)** Hardware Implementation & Single-Robot Integration — skeleton built
7. **(NEW)** Multi-Robot Swarm: Communication & Collaborative Mapping — skeleton built
8. **(NEW)** Perception & Victim Detection — skeleton built (standalone, DECIDED)
9. Experimental Results & Discussion — (was Ch.6) consolidate sim + hardware
10. Conclusion & Future Recommendations — (was Ch.7) update

File mapping in `chapters/`:
- chapter6_hardware.tex, chapter7_swarm.tex, chapter8_perception.tex = new skeletons
- chapter9_results.tex (renamed from chapter6_results), chapter10_conclusion.tex
  (renamed from chapter7_conclusion). All wired into main.tex in order 1→10.
- Skeletons use `% [TODO: ...]` placeholders for empty/teammate-owned sections.

## Work completed this session
- Reviewed entire thesis (all chapters, frontmatter, appendices, figures).
- Rewrote **Chapter 1** fully: Overview now spans sim+hardware + AUSRA name early +
  headline metrics; added 5th problem (sim-to-reality gap); added 4th objective group
  (Hardware Implementation & Swarm Integration); NEW section 1.5 Scope/Contributions/
  Deliverables; rewrote 1.6 Thesis Structure to 10-chapter layout; removed placeholder
  comments.
- Built skeletons for Ch.6/7/8; renamed results→9 and conclusion→10; retitled Ch.5;
  updated main.tex includes.

## Known inconsistencies to fix (semester-1 text vs real code)
- **Plate material/thickness**: Ch.3 says acrylic/6mm; Ch.6(old results) & conclusion
  say "3mm aluminum" + 275 MPa yield. RECONCILE.
- **Wheel radius**: abstract/BOM 58mm; Ch.3 r=0.0325; Ch.5 r=0.034. PICK ONE.
- **Encoder**: Ch.4 says 935 PPR; conclusion says 600 PPR; firmware uses TOTAL_CPR=1870
  (the corrected count — good validation anecdote).
- **Control loop**: text says 100 Hz; firmware SAMPLE_MS=50 → 20 Hz.
- **micro-ROS transport**: text says 921600/UART; firmware Serial 115200; launch send_ns
  uses stty 6000000. CONFIRM real value.
- **Battery/runtime/cost**: 2000 vs 5000 mAh; 72 min vs 1.8 hr vs 1.25 hr; $420 vs $777
  BOM. RECONCILE.
- **IMU**: text says MPU-9250; HW launch uses `mpu6050driver` package. CLARIFY.
- **Frontier**: Ch.5 describes custom package; HW uses `explore_lite`. CLARIFY in Ch.6.
- **"Sirius" legacy name** still appears in Ch.3 (rename to AUSRA).
- Unsupported "141.9% multi-robot improvement" stat in old results discussion.

## Chapter 2 — DONE (this session)
- Added §2.6 subsection "Greedy Frontier Exploration: explore_lite" (grounded in
  lidar_slam_pkg/config/explore_params.yaml; points to Ch.6 for params).
- Added §2.6 subsection "Multi-Robot Map Merging" (feature-based vs known-init-pose;
  AUSRA uses known_init_poses=true; grounded in ausra_map_merge_HW package.xml +
  map_merge_HW_params.yaml; points to Ch.7).
- Added bib entry `hornerexplore` (Hörner MSc thesis, source of m-explore stack) to
  backmatter/references.bib. Removed \url{} to avoid hyperref dependency.
- NOT yet build-tested: pdflatex/latexmk not installed in shell. Defer citation/xref
  confirmation (biber + 2× pdflatex) until toolchain available. chap:hardware &
  chap:swarm labels confirmed present; hornerexplore key confirmed added.

## Chapter 3 — IN PROGRESS (2026-06-20, session 2)
File: chapters/chapter3_mechanical.tex (706 lines). Option A fixes + both section
removals already on disk (see history below). Session 2 added the kinematics/motor-sizing
analysis and unit fixes. Build test still pending (no latexmk/pdflatex in shell).

### DECISION LOCKED
- Wheel radius = 0.0325 m (canonical: robot_controller.yaml, hardware_params.yaml,
  robot_core.xacro x3). The 0.034 value only appears in driver README (doc example).

### LANDED ON DISK (session 2)
- Diameter/radius unit fixes: L49/L51 "Maximum length of 30 cm" -> "Maximum diameter";
  L338 "total radius to exceed 0.3 m" -> "total diameter"; L401 "30 cm radius
  constraint" -> "30 cm diameter constraint". (Robot is circular; 30 cm is the diameter.)
- Motor-sizing derivation rewritten in "A. Determination of Motor Requirements" with
  reproducible equations (all use r = 0.0325 m):
  - eq:rpm_translation: n_trans = 60v/(2*pi*r) = 60*0.2/(2*pi*0.0325) ~ 59 RPM
  - eq:rpm_total: n_req = 60(v + R*wz)/(2*pi*r) ~ 85-90 RPM (R=0.124 m, wz~0.8 rad/s)
  - eq:total_force: F_total = m*a + m*g*Crr = 5*0.2 + 5*9.81*0.02 ~ 1.98 N
    (a=0.2 m/s^2, Crr=0.02, m=5 kg)
  - eq:wheel_torque: tau_w = F_total*r/3 ~ 0.022 N*m ~ 0.22 kg*cm; rated 0.8-1.0 kg*cm
  - Forward-references Ch.5 subsec:omni_driver for the full IK matrix (no duplication).

### KEY FINDING
- Ch.5 (chapter5_autonomous.tex, ~L1509-1654) already holds the FULL kinematics
  derivation: tab:wheel_config, eq:ik_general/eq:ik_numerical, eq:fk_general/
  eq:fk_numerical. Ch.3 must NOT duplicate it — only forward-reference.

### CONFLICT TO FIX IN CH.5 (deferred — user chose "Ch.3 now, list Ch.5 fixes")
- Ch.5 still uses old wheel radius 0.034. Change to 0.0325:
  - tab:wheel_config (~L1582): r_w 0.034 -> 0.0325
  - eq:ik_numerical (~L1625): "1/0.034" -> "1/0.0325" (= 30.77)
  - eq:fk_numerical (~L1652): prefactor "0.034" -> "0.0325"
  - Leave R=0.124 and 3R=0.372 unchanged.

### STILL TODO IN CH.3
- Add JGY-370 motor spec table (tab:jgy370_specs) after "E. Selection Rationale"
  (~L401). NOT on disk yet. CAUTION: encoder CPR unverified (firmware TOTAL_CPR=1870);
  confirm before adding an encoder row. (Table content uses $\geq$ / \,cm which kept
  triggering malformed tool calls — write it in small ASCII-only pieces.)
- Add Cytron MDD3A driver figure in "C. Integrated Power Control and Signal Integrity"
  (~L463, after fig:power_control). Asset: figures/Chapter 3/MDD3A_Motor_Driver_2_Channel.png.
- Language nits: L49 "constrain" -> "constraint"; L533 "noise the false readings"
  (punctuation); L266 sentence fragment.
- Materials-comparison table label cleanup (tab:acrylic_comparison only in stale .aux,
  no live \ref — safe to ignore).

### SUGGESTIONS RAISED BUT NOT YET APPROVED (do not act without user OK)
- Add a consolidated BOM / cost table to Ch.3 (or keep BOM only in appendix).
- Re-include a chassis-inspiration figure (Inspiration_design_for_the_chasis_v1.jpg/_v2.png).
- Add a short structural-justification note + one plate figure (instead of full FEA).
- Reconcile L73 "high-level board" promise with actual compute (Jetson Orin Nano).
- Unused FEA assets (Von_mises*, Displacement*, Safety_factor*, plate_assembly*) stay
  on disk, unreferenced — decide keep vs delete.

### Resolved this session
- All "Option A" typos confirmed fixed on disk (configuration dictates, balanced paren).
- FEA "Empirical Stress Analysis" (3.3.2) + "Evaluation of Materials" subsections: already
  removed; PLA-wall fact folded into plate-material para (L310). Ch9 keeps its OWN Von
  Mises section (independent — not affected).
- tab:acrylic_comparison: only in stale .aux artifact, no .tex \ref. Safe.
- "Max Length 30 cm" body text (L49/51) -> "Max Diameter" to match Table 3.1 (circular robot).
- Fixed two diameter/radius confusions: L338 + L401 said robot "radius" exceeds/fits 30 cm;
  30 cm is the DIAMETER limit (a 30 cm radius = 60 cm robot). Both corrected to "diameter".
- WHEEL RADIUS RESOLVED: real hardware value is **0.0325 m** (ausrabot_description/config/
  robot_controller.yaml, hardware_params.yaml, robot_core.xacro ×3). The 0.034 only appears
  in Omni-Directional-Driver/README (doc example, not runtime). Ch.3 L322 already correct.
  STILL TODO globally: reconcile Ch.5 (0.034) and abstract/BOM (58 mm = DIAMETER, i.e.
  0.029 m radius — note 58 mm diameter ≠ 0.0325 m radius; confirm which is the real wheel).

### Option A fixes — historical status (all now DONE)
- [DONE] Global "Sirius" -> "Ausra" rename. grep -c "Sirius" = 0 (verified).
- [DONE] Typo "configuration at dictates" -> "configuration dictates".
- [DONE] Paren "physical length > 90mm with encoder)" — now balanced;
  make "(physical length > 90 mm with encoder)".
- [TODO] Table 3.1 (tab:design_reqs, ~line 28): "Max Length: 30 cm" -> "Max Diameter:
  30 cm" (robot is circular; body text says diameter/width).
- [TODO] Heading ~line 625 "Empirical Stress Analysis" -> "Numerical Stress Analysis"
  (FEA is numerical, not empirical). NOTE: this whole section is slated for removal
  below — only rename if we KEEP a trimmed version; otherwise skip.
- [TODO] Remove the incorrect Denavit-Hartenberg sentence (~line 735): "...strictly
  adhered to the Denavit-Hartenberg (D-H) parameters." D-H is a serial-manipulator
  convention, wrong for an omni mobile base. Replace with a plain axis-alignment
  description (keep the surrounding TF-precision point).
- [TODO] Add missing \label{}s: chassis_options subfigures (~192-208) and the stress
  figures (~635-711) have no labels. Only needed for figs we keep.

### Section removals — DECIDED by user (remove completely)
User chose to delete the two weakest (semester-1, low thesis-relevance) sections.
A read-only cross-ref safety check was STILL PENDING when the connection dropped —
RUN IT FIRST next session before deleting:
  grep -rn "acrylic_comparison" chapters/ frontmatter/ backmatter/
  grep -rln "Von_mises|Safety_factor|plate_assembly|Stress Analysis|Evaluation of Materials" chapters/chapter*.tex
1. REMOVE 3.3.2 "Empirical Stress Analysis" (~lines 624-713): intro bullets, the
   3mm subsection (3 figs), the 6mm subsection (3 figs), comparison table
   tab:acrylic_comparison, and "All Three Layers Stress Analysis" (3 figs). ~9 figs.
2. REMOVE "Evaluation of Materials" subsection (chassis WALL, PLA-vs-Aluminum,
   ~lines 314-361): redundant with plate-material section + source of the material
   contradiction. Keep the PLA-wall fact as ONE sentence folded into the plate
   material discussion (so the enclosure section still makes sense).

### What deletion affects (tell user / handle)
- tab:acrylic_comparison label dies — safe ONLY if nothing \ref's it (the pending
  grep confirms). Likely unreferenced.
- Figures under figures/Chapter 3/ (Von_mises*, Displacement*, Safety_factor*,
  plate_assembly*) become unused — files can stay on disk, just not included.
- The "6mm acrylic" conclusion disappears, which actually REDUCES the material
  contradiction (old Ch.9/conclusion say "3mm aluminum"). Still must reconcile the
  real plate material/thickness globally (see Known inconsistencies).
- 3.3 intro mentions stress/load-bearing; after removing FEA, soften any sentence
  that promises a stress analysis so there's no dangling forward-reference.

### Open decisions still needed from user (do NOT guess)
- PLATE MATERIAL + THICKNESS: acrylic (ch3 selection) vs "3mm aluminum" (old
  ch9/conclusion). Need the REAL built value before reconciling globally.
- WHEEL RADIUS: 0.0325 m (ch3 L371) vs 0.034 (ch5) vs 0.058 m (abstract/BOM). Pick one.
- Whether to KEEP a 3-line FEA summary + 1 fig, or delete FEA entirely (user said
  remove completely -> default to full delete unless they say otherwise).

## Chapter 4 — IN PROGRESS (2026-06-20, professional rewrite)
File: chapters/chapter4_electrical.tex (~900 lines). Single source of truth =
`low-level/FREERTOS/` (FREERTOS.ino, Motor.cpp, PIDController.cpp, Config.h).
Plan: ~/.claude/plans/vectorized-percolating-ritchie.md.

### FIRMWARE GROUND TRUTH (verified from low-level/FREERTOS/ this session)
- TOTAL_CPR = 1997, LPF_ALPHA = 0.45, SAMPLE_MS = 30 (~33 Hz control loop).
- Encoder: attachInterrupt(CHANGE) on channel A + digitalRead(A)==digitalRead(B)
  for direction => X2 decoding (not X1, not X4).
- Dual-core FreeRTOS: microROSTask (Core 0, prio 1, 50 Hz publish via
  vTaskDelayUntil) + pidControlTask (Core 1, prio 5, 30 ms); mutex-guarded
  SharedRobotData struct (cmd targets down, joint pos/vel telemetry up).
- Ramp/slew limiter: MAX_ACCEL = 50 RPM/s^2; one common `scale` applied to all
  3 wheels => preserves velocity-vector direction while bounding acceleration.
- PID: Kp=10, Ki=10, Kd=0.01; anti-windup = integral clamp [-75,75] (constrain in
  PIDController::compute), NOT a PWM clamp; minPWM=30; setGains() for live tuning.
- Dead-zone: drive() does map(raw_pwm,0,255,minPWM,255); zero-target hard-stop.
- Transport: set_microros_transports() = serial @115200 (deployment). Agent =
  low-level/scripts/start_micro_ros_agent.sh -> `micro_ros_agent serial --dev
  /dev/ttyACM0 -b 115200` (also sends ns:<robot_namespace> over serial; esptool
  reset). WiFi/UDP 8888 = commented-out dev path only.
- Topics: SUBSCRIBES joint_group_velocity_controller/commands (Float64MultiArray);
  PUBLISHES joint_states (JointState). QoS = rmw_qos_profile_sensor_data (Best-Effort).

### LANDED ON DISK (Ch.4)
- 4.5.3 X1->X2 encoding rewrite (1997 CPR; X4~59,910/s vs X2~29,955/s; ~0.18 deg/count).
- 4.5.5 quantization -> 30 ms / ~33 Hz; EMA alpha 0.1 -> 0.45.
- 4.7 discrete PID intro Ts=0.03 s; 4.7.3 anti-windup -> integral clamp [-75,+75]
  (subsec:anti_windup, eq:anti_windup) with constrain(_integral+error*dt,-75,75).
- 4.7.4 REPLACED Ziegler-Nichols/MATLAB PID-tuner text with:
  - Dead-Zone Compensation (subsec:deadzone, eq:deadzone_map, minPWM=30).
  - Tuning Methodology (subsec:pid_tuning): Stage 1 free-air unloaded, Stage 2
    on-ground loaded via setGains(); eq:final_gains Kp=10/Ki=10/Kd=0.01.
- 1997 CPR landed at encoder sites; IRAM_ATTR isr1() listing updated.
- 4.8 Transport Layer Agnosticism reframed: USB Serial @115200 = Deployment
  (primary); UDP/Wi-Fi = Development Only (commented-out). Memory-footprint note
  de-Wi-Fi'd. (NOTE: used \SI{115200}{\baud} -- siunitx NOT confirmed loaded;
  MUST verify/replace with plain text before build.)

### STILL TODO IN CH.4
- 4.8 agent command (L738): `udp4 --port 8888` -> serial invocation
  (`micro_ros_agent serial --dev /dev/ttyACM0 -b 115200`, via
  start_micro_ros_agent.sh). Fix port-8888 sentence (L741).
- 4.8 topic names: create_topic example (L729) `/cmd_vel` -> real topics; QoS
  section (4.8 subsec:qos, L765-782) reframe from "Wi-Fi QoS" to transport-agnostic
  Best-Effort; fix `cmd_vel` mention (L773); section summary (L787) "50Hz motor
  control" -> distinguish 50 Hz publish vs ~33 Hz control.
- 4.8 \SI{}{\baud} -> plain "115200 baud" (siunitx not loaded -- VERIFY).
- REMOVE 4.9 "Evolutionary Architecture: Three-Phase Iteration" (Trial 1/2/3 logs,
  L794-868); fold into ~8-line "Architectural Iteration" paragraph in new fw section.
- ADD new "Firmware Architecture & Real-Time Implementation" section (after 4.8,
  before Summary): FreeRTOS dual-core task model (minimal why-RTOS); pidControlTask
  walkthrough listing; step->ramp section (max_change=MAX_ACCEL*dt, scale=
  max_change/max_diff, common-scale direction preservation); PID impl + tuning xref.
  Insert figure placeholders with % [TODO: add asset].
- UPDATE 4.10 Summary: still says 935 PPR / X1 / alpha=0.1 / Ziegler-Nichols /
  MATLAB / Wi-Fi QoS / three trials -> firmware reality.

### CROSS-CHAPTER FIXES (Ch.4 plan, deferred)
- chapter10_conclusion.tex L29: "100 Hz PID ... 600 PPR" -> "~33 Hz loop ... 1997 CPR".
- chapter10_conclusion.tex L91: drop ">1000 PPR upgrade" future-rec (already at 1997);
  re-point to higher loop rate.
- chapter9_results.tex L254 & L589: control-rate "50 Hz" -> "~33 Hz (30 ms)"; KEEP
  joint_states publish-rate 50 Hz where that is what is meant (distinguish the two).

### VERIFICATION (Ch.4, when toolchain available)
- grep returns nothing: 935 | 600 PPR | alpha.*0.1 | X1 encoding | udp4 --port 8888.
- grep present: 1997 | 0.45 | 30 ms | MAX_ACCEL | setGains.
- Confirm every new \ref{fig:...} has a matching \label (placeholder figures).
- Build: cd AUSRA_Thesis && latexmk -pdf main.tex (toolchain may be absent; fall
  back to brace/\label/\ref sanity grep + report).

### FIGURES THE USER MUST ADD (figures/Chapter 4/ has none of these)
1. FreeRTOS dual-core task diagram (Core 0 micro-ROS/comms vs Core 1 PID; mutex-
   guarded SharedRobotData; data-flow arrows). NEW asset.
2. Ramp vs step response plot (commanded step vs ramped setpoint vs measured RPM at
   50 RPM/s^2). Capture from telemetry.
3. PID step-response before/after tuning (free-air vs on-ground). Capture.
4. (optional) Block diagram of one motor channel: setpoint->ramp->PID->minPWM map->
   driver->encoder->LPF feedback.
5. (optional) ESP32-S3 wiring/pinout (3 encoders + 2 MDD3A) from Config.h pin map.
Items 1-3 get \ref'd placeholders so the build does not break.

## Suggested next steps
- Finish Ch.4 TODOs above (4.8 agent/topic/QoS, 4.9 removal, new fw section, 4.10
  summary, cross-chapter fixes), then build-verify.
- Option B: Start filling Chapter 6 content (6.1 sim->hw overview, 6.2 compute bring-up).
- Then proceed section-by-section.

