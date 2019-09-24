# Palmprint Segmentation

Matlab source code for palmprint segmentation used in the papers:

	A. Genovese, V. Piuri, K. N. Plataniotis, and F. Scotti,<br/>
	"PalmNet: Gabor-PCA Convolutional Networks for Touchless Palmprint Recognition",<br/>
	IEEE Transactions on Information Forensics and Security, 2019.<br/>
	DOI: 10.1109/TIFS.2019.2911165<br/>
	https://ieeexplore.ieee.org/document/8691498
    
	A. Genovese, V. Piuri, F. Scotti, and S. Vishwakarma,<br/>
	"Touchless palmprint and finger texture recognition: A Deep Learning fusion approach", <br/>
	2019 IEEE Int. Conf. on Computational Intelligence & Virtual Environments for Measurement Systems and Applications (CIVEMSA 2019),<br/>
	Tianjin, China, June 14-16, 2019
	
Project pages:

- PalmNet: Gabor-PCA Convolutional Networks for Touchless Palmprint Recognition: <br/>
http://iebil.di.unimi.it/palmnet/index.htm
- Touchless palmprint and finger texture recognition: A Deep Learning fusion approach: <br/>
http://iebil.di.unimi.it/fusionnet/index.htm
    
Outline:
![Outline](http://iebil.di.unimi.it/palmnet/imgs/outline_segm_small.jpg "Outline")

Citation:

    @Article{tifs19,
        author = {A. Genovese and V. Piuri and K. N. Plataniotis and F. Scotti},
        title = {PalmNet: Gabor-PCA Convolutional Networks for Touchless Palmprint Recognition},
        journal = {IEEE Transactions on Information Forensics and Security},
        year = {2019},
        note = {1556-6013}
    }
   
    @InProceedings {civemsa19,
        author = {A. Genovese and V. Piuri and F. Scotti and S. Vishwakarma},
        booktitle = {Proc. of the 2019 IEEE Int. Conf. on Computational Intelligence & Virtual Environments for Measurement Systems and 	Applications (CIVEMSA 2019)},
        title = {Touchless palmprint and finger texture recognition: A Deep Learning fusion approach},
        address = {Tianjin, China},
        month = {June},
        day = {14-16},
        year = {2019},
    }

Main files:

- launch_PalmSeg.m: main file
- ./params/params_Tongji_Contactless_Palmprint_Dataset.m: parameter file for the Tongji database<br/>
      (http://sse.tongji.edu.cn/linzhang/cr3dpalm/cr3dpalm.htm)

Required files:

- ./images/Tongji_Contactless_Palmprint_Dataset/: 
Database of images, with filenames in the format "NNNN_SSSS.ext", 
where NNNN is the 4-digit individual id, SSSS is the 4-digit sample id, and ext is the extension. <br/>
For example: "0001_0001.bmp" is the first sample of the first individual. 
In the paper, left and right palms of the same person are considered as different individuals.

Part of the code is based on the papers:

- O. Bingol and M. Ekinci, <br/>
“Stereo-based palmprint recognition in various 3D postures,” <br/>
Expert Syst. Appl., vol. 78, pp. 74–88, 2017.<br/>
https://www.sciencedirect.com/science/article/pii/S0957417417300350
    
- K. Ito, T. Sato, S. Aoyama, S. Sakai, S. Yusa, and T. Aoki, <br/>
“Palm region extraction for contactless palmprint recognition,” <br/>
in Proc. 2015 Int. Conf. on Biometrics (ICB), May 2015, pp. 334–340.<br/>
https://ieeexplore.ieee.org/abstract/document/7139058
    
- G. K. O. Michael, T. Connie, and A. B. J. Teoh, <br/>
“Touch-less palm print biometrics: Novel design and implementation,” <br/>
Image Vis. Comput., vol. 26, no. 12, pp. 1551–1560, 2008.<br/>
https://www.sciencedirect.com/science/article/pii/S0262885608001406
    
- T. Connie, A. B. J. Teoh, M. G. K. Ong, and D. N. C. Ling, <br/>
“An automated palmprint recognition system,” <br/>
Image Vis Comput., vol. 23, no. 5, pp. 501–515, 2005.<br/>
https://www.sciencedirect.com/science/article/pii/S0262885605000089
    
The databases used in the papers can be obtained at:

- CASIA:<br/>
http://www.cbsr.ia.ac.cn/english/Palmprint%20Databases.asp
- IITD:<br/>
http://www4.comp.polyu.edu.hk/~csajaykr/IITD/Database_Palm.htm
- REST:<br/>
http://www.regim.org/publications/databases/regim-sfax-tunisian-hand-database2016-rest2016/
- Tongji:<br/>
http://sse.tongji.edu.cn/linzhang/cr3dpalm/cr3dpalm.htm
	
