# h2pc_installer
NSIS Based Installer for Halo 2 PC and Project Cartographer

I basically split up the required game files in two sources. All the maps and some dependencies are found in separate zip files (files1.zip, files2.zip files3.zip). The installer script unzips the maps to the install directory maps folder. Separately, the install script packages the setup.exe with the rest of the required files, such as halo2.exe and all the various other files in the install folder. 

Install logic:
1. Select install folder
2. Unzip filesX.zip to install/maps
3. Install the rest of the files to where they need to go in the install/ folder
4. Install dependencies silently (without user input) Install Visual C++ 2005 (required for halo2.exe)
5. Install .NET 4.5.2 (required for launcher)
6. Install DirectX 9.0c (required for halo2.exe)
7. Finish install and run the launcher to login 
