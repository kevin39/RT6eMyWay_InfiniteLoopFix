RT6eMyWay_InfiniteLoopFix
=========================

A fix for RT6/eMyWAY navigation system. This fix will help you to fix the "Infinite loop" bug when updating POI.

Bug causes :
- Mac OS system add a lot of hidden files starting with a dot. Originally, RT6/eMyWay system doesn't ignore these file but import them 
into into the GPS memory. After importing these files, the GPS is to update anymore its database.

Bug fix : 
- The script remove all temp file  but doesn't fix the problem itself. You'll can update you RT6 with a clean USB-key.


How to run
=========================

* USE A PC
* Copy all files on a cleaned USB drive
* Start your engine
* Put the USB drive
* Run the script
* Wait few secs
* Enjoy!
