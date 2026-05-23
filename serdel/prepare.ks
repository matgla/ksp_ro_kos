print "Preparing ship for launch...".
runpath("0:/common/wait_for_fueling.ks").

// for res in ship:resources {
//     print "Checking resource: " + res:name.
//     if res:name:toLower() = target {
//         print "Found " + res:name + " amount = " + res:amount.
//         break.
//     }
// }
// 
// local prevLF is ship:resources:ethanol75:amount.
// print "Current fuel level: " + prevLF + " units.".
//wait 1.
//local currLF is ship:resources["LqdOxygen"]:amount.
//
//until currLF > prevLF {
//    set prevLF to currLF.
//    wait 1.
//    set currLF to ship:resources["LqdOxygen"]:amount.
//    print "Current fuel level: " + currLF + " units.".
//}
//
//print "Fuel loading complete.".
