### Lundi 18/11/2019
**Matin**  
* Clé + présentation du projet + impression des articles de biblio(HD général, DB specific, thesis). Mise au point sur les données disponibles & methodes d'analyses (SYCER, HOMER). (Feuille de note papier)  
* Lecture de l'article *Cell-type specific gene epxression profiling in Adult mouse brain reveals normal and disease-state signatures*  

**Après-midi**  
* Fin lecture premier article  
* Lecture de l'article "Huntington disease" Gillian P. Bates, PRIMER  
* Lecture de l'article "The pathobiology of perturbed mutant Huntingtin protein-protein interactions in Huntington's diseases", E. Wanker  
* Mise à plat des problématiques et des analyses possible dans le cadre du projet dans le cahier Projet.md
* Lecture de partie de la thèse de Caroline Lotz: "Rôle des altérations transcriptionnelles et épigénétiques dans le déficits comportementaux de la maladie de Huntington"

### Mardi 19/11/2019
**Matin**  
* Creation de script permettant de générer des volcano plot à partir de nos données d'exemples
* Adaptation de ce script sous forme de fonction ré-utilisable

**Après-midi** 
* Fin script Volcano plot
* Réunion de groute avec Karine, Johnattan, Raphael
* Début de script biomaRt pour convertir nos gènes humains en gènes de sourie
* GLT astrocytes ; Cx3: Microglie. Récupération des fichiers cell-type spec, tentative de merge.

### Mercredi 20/11/2019
**Matin**
* Résolution probleme merging fichier de cell type
* Script de récupération de gene name vs ensembl ID
* Début de script de analyse cell type transcriptomics

**Après-midi**
* Creation d'un script créant une matrice de présence absence des gènes cell-types spécific filtré ou non avec les interacteurs
* Refactoring du code de volcano plot et doc
* Séparation des fonctions de volcano plot dans un fichier source, commentés contenant que les fonctions
* Début travaux sur fonction d'extraction des LFC de genes