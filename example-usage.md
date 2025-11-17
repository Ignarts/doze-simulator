# Examples

## Basic Doze Simulation

```bash
doze-simulator --package=com.example.app --wait=30
```

**Output:**

```
[1/5] Unplugging battery...
[2/5] Forcing Doze idle mode...
[3/5] Setting app inactive (App Standby)...
[4/5] Waiting:
1/30 ... 30/30

[5/5] Releasing Doze state...

--- SIMULATION COMPLETE --
```

## Verbose Mode

```bash
doze-simulator -p com.example.app -w 45 -v
```

**Output:**

```
[INFO] Using package: com.example.app
[INFO] Simulated wait: 45 seconds

[1/5] Unplugging battery...
→ adb shell dumpsys battery unplug

[2/5] Forcing Doze idle mode...
→ adb shell dumpsys deviceidle force-idle

[3/5] Setting app inactive...
→ adb shell am set-inactive com.example.app true

[4/5] Waiting...
Waiting:
1/45 ... 45/45

[5/5] Releasing Doze...
→ adb shell dumpsys deviceidle unforce
--- SIMULATION COMPLETE --
```

## Disable Colors (CI environments)

```bash
doze-simulator --package=com.example.app --wait=60 --no-colors
```

**Output:**

```
[1/5] Unplugging battery...
[2/5] Forcing Doze...
[3/5] Setting app inactive...
[4/5] Waiting:
1/60 ... 60/60

[5/5] Releasing Doze...
--- SIMULATION COMPLETE --
```

## Reactivate the App at the End

```bash
doze-simulator -p com.example.app -w 20 --activate
```

**Output:**

```
[1/6] Unplugging battery...
[2/6] Forcing Doze...
[3/6] Setting app inactive...
[4/6] Waiting:
1/20 ... 20/20

[5/6] Releasing Doze...
[6/6] Reactivating app: com.example.app

--- SIMULATION COMPLETE --
```

## Full Command with All Flags

```bash
doze-simulator --package=com.example.app --wait=45 --verbose --no-colors --activate
```

**Output:**

```
[INFO] Colors disabled
[INFO] Verbose mode enabled
[INFO] Package: com.example.app
[INFO] Wait time: 45 seconds

[1/6] Unplugging battery...
→ Battery unplug forced

[2/6] Forcing Doze idle mode...
→ Doze deep idle forced

[3/6] Forcing app into App Standby...
→ App set to inactive

[4/6] Waiting to simulate idle...
Waiting:
1/45 ... 45/45

[5/6] Releasing Doze...
→ Doze unforced

[6/6] Reactivating app...
→ Marking app as active (set-inactive false)

--- SIMULATION COMPLETE --
```
