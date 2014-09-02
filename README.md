RT6eMyWay_InfiniteLoopFix
=========================

A fix for RT6/eMyWAY in car navigation system. This fix willl help you to solde the "Infinite loop" bug about updating POI.

Bug causes :
- Mac OS system add a lot of hidden files starting with a dot. Originally, RT6/eMyWay system doesn't ignore these file but import them 
into into the GPS memory. After importing these files, the GPS is now unable to update its database.

Bug fix : 
- The script remove all temp file locked but doesn't fix the problem. You'll can update you RT6 with a USB-key prepared on a Mac
or cleaned.