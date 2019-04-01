## Open CASCADE JT Assistant
https://www.opencascade.com/content/jt-assistant

### Missing libraries with JTAssistant
- Navigate to the folder containing the jtassistant*.tgz file  
- Unpack the `jtassistant*.tgz` file  
`tar -xvzf jta*.tgz`
- navigate into the unpacked ‘lin64’ directory  
`cd lin64`  
- Attempt to execute JTAssistant application  
`./JTAssistant.sh`  
- Patch [known issue of missing (unecessary) libraries](https://www.opencascade.com/content/missing-libraries-jtassistant)  
```
ln -s libTKernel.so.0 libTKBRep.so.0
ln -s libTKernel.so.0 libTKG2d.so.0
ln -s libTKernel.so.0 libTKG3d.so.0
ln -s libTKernel.so.0 libTKGeomBase.so.0
rm libz.so.1
```
- Attempt to execute JTAssistant application  
`./JTAssistant.sh`  

tested on:
openSUSE tumbleweed 2019/03
Fedora 29
