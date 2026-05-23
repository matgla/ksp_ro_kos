print "=== Emez Inc ===".
set shipName to ship:name.
print "Welcome aboard the " + shipName + "!".
print "Mission Control initialization in progress...".

set splitName to shipName:split("-").
if splitName:length < 2 { 
    print "ERROR Unable to determine model information from ship name.".
}

set shipModel to splitName[0].
set shipModel to shipModel:split(" ")[0].
print "Ship model identified as: " + shipModel.
set shipMission to splitName[1].
print "Mission type: " + shipMission.

set shipModel to shipModel:tolower().
set missionPath to shipModel + "/missions/" + shipMission:trim().
if not exists(missionPath) {
    print "ERROR Mission files not found for model " + shipModel + " and mission " + shipMission + ".".
    print "Please contact Emez Inc support for assistance.".
    print "Available missions for this model:".
    set missionDir to shipModel + "/missions".
    set pathDir to path(missionDir).
    list files in pathDir.
    abort.
}

print "Performing pre-launch checks...".
set prepareScript to "0:/" + shipModel + "/prepare.ks".
runpath(prepareScript).

print "Loading mission from: " + missionPath + "...".
// this one runs on vehicle, compile and run 

