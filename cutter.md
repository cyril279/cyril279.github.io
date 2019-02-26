# Cutter/Plotter via linux

### InkCut! 2019/10  
https://github.com/codelv/inkcut  
https://codelv.com/projects/inkcut/  
https://www.codelv.com/projects/inkcut/docs/  
https://inkscape.org/news/2011/03/16/meet-inkcut-vinyl-cutter-and-vectors-plotter/  

### Installation  
`zypper in python3-{pip,qt5,pyside2,service_identity}`  
`pip3 install git+https://github.com/codelv/inkcut.git`  

### Cutter: PII-60

Model	| PII-60
--:	| :--
Max.Cutting Width	| 590mm(23.23in)
Max.Media Loading Width	| 719mm(28.3in)
Max. Cutting Speed	| Up to 600 mm /sec (23.62 ips)
Data Buffer Size	| 4MB
Interfaces	| USB 1.1 & Parallel (Centronics) & Serial (RS-232C,9600 baud)
Commands	| HP-GL, HP-GL/2

### Setup Notes
**Serial connection** may return `/dev/ttyS0: Permission denied` unless user added to `dialout` group. [details](https://askubuntu.com/a/210230)  
> **Cutters with a parallel interface** (either a 'real' parallel port or using a built-in parallel-to-USB converter) must be added to your system as a printer before using them from Inkcut. Start your printer configuration utility (e.g. system-config-printer), which at least when connecting via USB should detect the connected cutter. Proceed to add it with the 'Generic' 'Raw Queue' driver.

**linux logo files as pdf,svg,ai**  
https://github.com/unixstickers/foss-swag-designs  
https://en.opensuse.org/openSUSE:Artwork_brand  
https://www.trzcacak.rs/myfile/full/60-604916_starbucks-logo-clip-art-8117482-gnu-linux-freedom.png  
https://en.opensuse.org/openSUSE:Artwork_brand#Buttons  

[Tux Plot](http://securetech-ns.ca/tuxplot.html) 
