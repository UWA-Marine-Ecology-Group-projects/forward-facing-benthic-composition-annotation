[Annotation guide: benthic composition and relief for horizontally facing imagery](https://docs.google.com/document/d/1c0lo-wQbJqHk0GPm824wP3o2zVROBeT_G25M46eV6js/edit?usp=sharing)

Contents


[TOC]



## Benthic composition and relief for horizontally facing imagery

Summary paragraph about benthic imagery


## TransectMeasure - Standard Operating Procedure

We have developed a simple approach to characterise benthic composition and complexity from horizontally facing imagery (including stereo-BRUVs and panoramic drop cameras), adapting existing standardised schema for benthic composition ([CATAMI classification scheme](https://github.com/catami/catami.github.com/blob/master/catami-docs/CATAMI%20class_PDFGuide_V4_20141218.pdf)) and benthic complexity <sup><a href="https://paperpile.com/c/0wnItn/M1vE">1</a></sup>.

The annotation approach is rapid and produces point annotation-level composition and mean and standard deviation estimates of complexity, which enable flexible modelling of habitat occurrence and fish-habitat relationships. A set of scripts to ensure quality assurance and quality control are also provided.


### 1. Load images and attribute file



* Open the program TransectMeasure and you will be welcomed with a blank screen (Figure 1).
* To start an analysis for a new set of images: “Measurement” > “New measurement file” (Figure 2). Select “Read from file ...”.
* Locate the folder where your images have been stored: “Picture” > “Set picture directory ...” (Figure 3).
* Load the first image to be analysed: “Picture” > “Load picture ...” (Figure 3).
    * Retake images if they are unfocused and blurry or when visibility is low.
    * For stereo-BRUV imagery, left images are annotated, and for panoramic drop camera imagery, top images are annotated.
* To load the attribute file containing all of the CATAMI habitat classification codes: “Measurements” > “Load attribute file ...” > The attribute file is a text file containing the information necessary for populating the drop down tabs when classifying your image (Figure 4). This is available for download via [CheckEM](https://marine-ecology.shinyapps.io/CheckEM/) - ‘Schema downloads’. 

<img src="https://raw.githubusercontent.com/benthic-bruvs-field-manual/Benthic-BRUVs-field-manual.github.io/master/images/figures/hab1.jpg">

#### Figure 1: TransectMeasure initial opening screen. 



<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image2.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image2.jpg "image_tooltip")



#### Figure 2: Creating a new measurement file in TransectMeasure.



<p id="gdcalert3" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image3.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert4">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image3.jpg "image_tooltip")



#### Figure 3: Setting the picture directory and loading the image in TransectMeasure.



<p id="gdcalert4" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image4.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert5">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image4.png "image_tooltip")



#### Figure 4: Loading the attribute file in TransectMeasure.


### 
2. Setting and overlaying the annotation points and adding frame information



* To set up the area of interest: Hold shift and left click on the four corners of the rectangle that forms the lower 50% of the image > Right click > “Add new area of interest” (Figure 5). 

NOTE: To accurately overlay an area of interest over the lower 50% of the image, you can firstly overlay gridded dots with rectangles (“Measurements” > “Dot configuration ...”. Set accordingly: Gridded dots, ‘Dots across image’ = 1, ‘Dots down image’ = 2 and check the “Overlay rectangles” box) and use the border of the rectangles as a guide. 



* To set up the points: “Measurements” > “Dot configuration ...”. Set accordingly: Random dots, ‘Number of dots’ = 20 (Figure 6). This will allow you to classify the benthic composition according to 20 randomly generated points over the lower 50% of the screen. You should only need to change these settings the first time you use the program on your computer.
* To overlay the points: Right click on an image and select “Overlay dots” (Figure 7). The name of the image will then appear in the table to the left of the image. For all subsequent images, you can use “ctrl + i” to add the last used area of interest and overlay random dots (Figure 8). 

NOTE: To annotate composite imagery, multiple areas of interest will need to be added corresponding to the images contained in the composite image. For the first area of interest, points can be added following the steps detailed above. For the remaining images within the composite image, points can be added to the existing points by specifying a new area of interest, and then using “ctrl + right click + Add dots” > “Add to the existing points” (Figure 9). For all subsequent images, “ctrl + shift + i” will overlay the last area of interest and add random dots to the image. 



* To set the frame information: After the image has been annotated, use “ctrl + t” to automatically fill information stored in the image filename into the frame information fields (when prompted review the autofill information and select “Yes”). 

NOTE: This autofill information uses the filename structure that is automatically generated when exporting habitat images from EventMeasure (Right click > “Save as jpeg”. If you wish to use this feature, you must either export your images from EventMeasure, or name your images to match the following structure - ‘OpCode_Period_ImageName’. TransectMeasure will detect the first 2 underscores as separators and parse the information from these into the frame information fields.



<p id="gdcalert5" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image5.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert6">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image5.png "image_tooltip")



#### Figure 5: Adding a new area of interest in TransectMeasure.



<p id="gdcalert6" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image6.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert7">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image6.png "image_tooltip")



#### Figure 6: Setting the dot configuration in TransectMeasure.



<p id="gdcalert7" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image7.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert8">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image7.png "image_tooltip")



#### Figure 7: Adding dots in TransectMeasure.



<p id="gdcalert8" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image8.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert9">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image8.png "image_tooltip")



#### Figure 8: Example of a stereo-BRUV image with random points added to the lower 50% of the image ready for annotation. 



<p id="gdcalert9" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image9.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert10">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image9.png "image_tooltip")



#### Figure 9: Example of a panoramic drop camera image with random points added to the lower 50% of each image ready for annotation. The red box in the bottom right image denotes the custom area of interest used to overlay the annotation points in TransectMeasure.


### 
3. Classifying the benthic composition in an image



* Left click on a point to display the “Attribute editor” (Figure 10)
* Select the biota that lies directly underneath the point from the “level_2” dropdown (includes benthos, un/consolidated substrate, open water and unknown). If the point lands on the bait arm, bait bag or a part of the frame, you should select “unknown” in the “level_2” dropdown (Figure 8).

Note: Zoom into an image to analyse the benthic composition more closely by adjusting the "Zoom" value at the top left of the window before holding down the ctrl key and hovering your cursor over the area that you would like to zoom to.



* Continue to populate each dropdown (where possible) after “level_2” (i.e. “level_3” > “level_4” > “level_5” > “scientific” > “qualifiers”). Available selections will change depending on the value selected in the previous level. Select “Clear” to reset the dropdowns for all of the categories (Figure 10).
* The dropdown for “Code” is automatically filled by an eight digit code once all possible categories have been selected for that point. Codes are sourced from the [Categories for Australian Aquatic Biota database](https://www.cmar.csiro.au/caab/).



<p id="gdcalert10" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image10.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert11">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image10.png "image_tooltip")



#### Figure 10: The ‘attribute editor’ window within TransectMeasure.


### 
4. Classifying the relief of an image

Annotation of relief will need to be annotated in a separate TransectMeasure file (.TMObs), which can be set up by following the same steps defined in ‘1. Load images and attribute file’. A separate schema for relief is available for download via [CheckEM](https://marine-ecology.shinyapps.io/CheckEM/) - ‘Schema downloads’.  



* To set up the grid: “Measurements” > “Dot configuration ...”. Set accordingly: Grided dots, ‘Dots across image’ = 5, ’Dots down image’ = 4 and check the “Overlay rectangles” box (Figure 11). This will allow you to classify the relief according to 20 gridded points. You should only need to change these settings the first time you use the program on your computer.
* To overlay the grid: Right click on an image and select “Overlay dots” (Figure 12). The name of the image will then appear in the table to the left of the image. 

NOTE: For composite imagery that consists of multiple images, gridded dot configuration can be changed to reflect multiple images. For panoramic drop camera imagery containing four images, we overlay 10 dots across the image and 8 dots down the image (Figure 14). 



* Left click on a point to display the “Attribute editor” (Figure 15)
* Select the relevant relief score for the whole rectangle from the “Relief” dropdown. 
* The dropdown for “Relief” indicates the structural complexity of the substrate and associated benthos. This dropdown includes six distinct categories adapted from Wilson et al. (2006), which are;
    * **0. **Flat substrate, sandy, rubble with few features. ~0 substrate slope
    * **1.** Some relief features amongst mostly flat substrate/sand/rubble. &lt;45 degree substrate slope
    * **2. **Mostly relief features amongst some flat substrate or rubble. ~45 substrate slope
    * **3. **Good relief structure with some overhangs. >45 substrate slope
    * **4. **High structural complexity, fissures and caves. Vertical wall. ~90 substrate slope.
    * **5. **Exceptional structural complexity, numerous large holes and caves. Vertical wall. ~90 substrate slope.

NOTE: Any ‘rectangle’ that has some form of benthos/substrate visible should be classified for _Relief _(even if open water makes up the majority of the grid). The relief score for rectangles that are entirely composed of open water should be left blank.



<p id="gdcalert11" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image11.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert12">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image11.png "image_tooltip")



#### Figure 11: Setting the dot configuration in TransectMeasure.



<p id="gdcalert12" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image12.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert13">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image12.png "image_tooltip")



#### Figure 12: Adding dots to an image in TransectMeasure.



<p id="gdcalert13" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image13.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert14">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image13.png "image_tooltip")



#### Figure 13: Example of a stereo-BRUV image annotated for relief.


#### 

<p id="gdcalert14" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image14.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert15">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image14.png "image_tooltip")
Figure 14: Example of a panoramic drop camera composite image annotated for relief.



<p id="gdcalert15" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image15.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert16">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image15.png "image_tooltip")



#### Figure 15: The ‘attribute editor’ window within TransectMeasure.


### 
5. Saving and exporting from TransectMeasure



* To save your work: “Measurements” > “Write to file ...” (Figure 16). This creates a *.TMObs file where your benthic classifications will be saved.
* To export TMObs file: “Program” > “Batch text file output ...” (Figure 17)
* The following box should appear: Double click to the right of the ✓ (under “Data”) in the “Input file directory” row, then locate the folder where your *.TMObs file has been saved, do the same for the “output file directory” to specify the folder location for saving your text file (Figure 18). Now select “Process”. This will generate an output text file that can be processed using the scripts included in the GitHub repository (see ‘Annotation summary and quality control’). 

NOTE: In order for ‘OpCode’ and ‘Period’ to be included in the final data outputs, you will need to select this option from … . You will only need to do this once per computer. 



<p id="gdcalert16" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image16.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert17">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image16.jpg "image_tooltip")



#### Figure 16: Writing to file in TransectMeasure in order to save image observations.



<p id="gdcalert17" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image17.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert18">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image17.jpg "image_tooltip")



#### Figure 17: The ‘batch text file output’ option in TransectMeasure.



<p id="gdcalert18" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image18.jpg). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert19">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image18.jpg "image_tooltip")



#### Figure 18: Input and output file directory options for batch text file outputs in TransectMeasure.


### Recommended approaches

For standard (rapid) assessment of _Benthic Composition_ and _Relief _we recommend using ONLY the: “BROAD” classification within the _Benthic Composition_ and _Relief_. An experienced analyst would be able to annotate this schema to over 200 images a day.

**OR**

For detailed assessment of _Benthic Composition_ (where coral bleaching or macroalgae composition was of interest) and _Relief_ we recommend using all the classes in _Benthic Composition_ (“BROAD” > “MORPHOLOGY” > “TYPE” and _Relief_. An experienced analyst would be able to annotate this schema to over 120 images a day.


## Annotation summary and quality control

All corrections should be made within the original annotation files to ensure data consistency over time. We recommend the following approaches to ensure quality control:



* Check that all annotation points have been assigned values (see R scripts included in the GitHub repository - ‘[forward-facing-benthic-composition-annotation](https://github.com/UWA-Marine-Ecology-Group-projects/forward-facing-benthic-composition-annotation)’).
* Check that the image names match the metadata sample names.
* Check all successful deployments have benthic composition data.
* Visually assess data for trends, outliers and potential errors (Figures 19 & 20).
* Spatially visualise the data for patterns in the distribution of key habitat classes (Figure 21).



<p id="gdcalert19" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image19.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert20">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image19.png "image_tooltip")



#### Figure 19: Visualisation of the raw habitat data generated using the scripts provided. 



<p id="gdcalert20" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image20.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert21">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image20.png "image_tooltip")



#### Figure 20: Visualisation of the raw structural complexity (relief) data generated using the scripts provided. 



<p id="gdcalert21" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image21.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert22">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image21.png "image_tooltip")



#### Figure 21: Spatial visualisation of key habitat classes generated using the scripts provided. 


## Squidle+ - Standard Operating Procedure


## Examples of publications that have used this or earlier versions of this SOP


    1.	Wilson, S. K. et al. Multiple disturbances and the global degradation of coral reefs: are reef fishes at risk or resilient? Glob. Chang. Biol. 12, 2220–2234 (2006).


    2.	McLean, D. L. et al. Distribution, abundance, diversity and habitat associations of fishes across a bioregion experiencing rapid coastal development. Estuarine, Coastal and Shelf Science 178, 36–47 (2016).


    3.	McLean, D. L. et al. Using industry ROV videos to assess fish associations with subsea pipelines. Cont. Shelf Res. 141, 76–97 (2017).


    4.	Bond, T. et al. The influence of depth and a subsea pipeline on fish assemblages and commercially fished species. PLoS One 13, e0207703 (2018).


    5.	Bond, T. et al. Fish associated with a subsea pipeline and adjacent seafloor of the North West Shelf of Western Australia. Mar. Environ. Res. 141, 53-65 (2018).


    6.	Bond, T. et al. Diel shifts and habitat associations of fish assemblages on a subsea pipeline. Fish. Res. 206, 220–234 (2018).


    7.	Lester, E. et al. Drivers of variation in occurrence, abundance, and behaviour of sharks on coral reefs. Sci. Rep. 12, 728 (2022).


    8.	Lester, E. et al. Relative influence of predators, competitors and seascape heterogeneity on behaviour and abundance of coral reef mesopredators. Oikos 130, 2239–2249 (2021).


    9.	Rolim, F. A. et al. Network of small no-take marine reserves reveals greater abundance and body size of fisheries target species. PLoS One 14, e0204970 (2019).


    10.	Rolim, F. A. et al. Baited videos to assess semi-aquatic mammals: occurrence of the neotropical otter Lontra longicaudis (Carnivora: Mustelidae) in a marine coastal island in São Paulo, Southeast Brazil. Mar. Biodivers. 49, 1047-1051 (2018).


    11.	Haberstroh, A. J. et al. Baited video, but not diver video, detects a greater contrast in the abundance of two legal-size target species between no-take and fished zones. Mar. Biol. 169, 79 (2022).


    12.	Piggott, C. V. H. et al. Remote video methods for studying juvenile fish populations in challenging environments. J. Exp. Mar. Bio. Ecol. 532, 151454 (2020).


    13.	MacNeil, M. A. et al. Global status and conservation potential of reef sharks. Nature 583, 801–806 (2020).


    14.	Goetze, J. S. et al. Drivers of reef shark abundance and biomass in the Solomon Islands. PLoS One 13, e0200960 (2018).
