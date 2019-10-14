# VariousScripts

KillByProduct: vbscript that uses powershell to find processes by product name and vbscript to kill them.

''PDQ Condition based on Model:'' This is to check PC model before moving to next step, if success codes are only set to only 0 in the package then this should fail when the model doesn't match and prevent the next step from executing. Failure will exit with value of 1.
If you set the error mode to "Stop deployment with success" with will mean the package can be skipped without error.
