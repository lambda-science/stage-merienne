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
* Fonctionnement extraction LFC Genes ->  
    *D2+Interactors:*  
        **Gm7879**: PPIase that catalyzes the cis-trans isomerization of proline imidic peptide bonds in oligopeptides and may therefore assist protein folding. Participates in pre-mRNA splicing. May play a role in the assembly of the U4/U5/U6 tri-snRNP complex, one of the building blocks of the spliceosome. May act as a chaperone -- **Peptidyl-prolyl cis-trans isomerase H**  
        **Eno1b**: Glycolytic enzyme the catalyzes the conversion of 2-phosphoglycerate to phosphoenolpyruvate. In addition to glycolysis, involved in various processes such as growth control, hypoxia tolerance and allergic responses. May also function in the intravascular and pericellular fibrinolytic system due to its ability to serve as a receptor and activator of plasminogen on the cell surface of several cell-types such as leukocytes and neurons. Stimulates immunoglobulin production. -- **Alpha-enolase**  
        **Hspa1b**: Molecular chaperone implicated in a wide variety of cellular processes, including protection of the proteome from stress, folding and transport of newly synthesized polypeptides, activation of proteolysis of misfolded proteins and the formation and dissociation of protein complexes. Plays a pivotal role in the protein quality control system, ensuring the correct folding of proteins, the re-folding of misfolded proteins and controlling the targeting of proteins for subsequent degradation.  -- **Heat shock 70 kDa protein 1B**  
        **Serpina3n**: The single human alpha1-antichymotrypsin gene (SERPINA3) is represented by a cluster of 14 individual murine paralogs. -- **Serine protease inhibitor A3N** - secreted  


### Jeudi 21/11/2019
**Matin**
* Creation rapport rmarkdown volcano plot cell-type specific
* Résolution de problême d'affiche de dataframe interactif en utilisant https://github.com/rstudio/DT/issues/67
* Etat avancement avec Johnattan ; update to-do list

**Après-midi**
* Transfert rapport à Karine
* Update de fontions
* Récupération données complète de transcriptomes cell types spec

### Vendredi 22/11/2019
**Matin**
* Génération et envoie du rapport avec les nouvelles données
* Intégration d'un test bionomial au rapport pour tester l'enrichissement en interacteurs

**Après-midi**
* Thèse de David
* Préparer un r-data avec volcano et rapport

### Lundi 25/11/2019
**Matin**  
* Travail sur fonction de stacking pour refaire les analyses
* Fiche récap des caract des deux données dispo
* Checking des données, adaptations des seuil LFC (beaucoup moins stringeants)
* Adatation test binomial avec proba de reference (biais initial)
* Envoie du nouveau rapport

**Après-midi**  
* Creation rapport learning
* REGLAGE DE BUG A CAUSE VIRGULE A LA PLACE DE POINT DANS EXCEL
* MISSING ROW à investiguer

### Mardi 26/11/2019  
**Matin**  
* Conversion des rapport en PDF: missing row dans certains cas car missing value padj
**CONDITION LEARN**  
* Probe = jour du test ; Homecage = vrai controle 
* Probe / Learn = juste temps différents
* Voire juste chez WT Probe vs WT HC si y'a des intéracteurs qui agissent. Si oui: regarder chez WT Learn / HC si ça arrive avant test 

* Croiser gene peak annotation w/ interactor list (small file)
* Réunion avec Jonathan sur l'aspect code / package developpement et consignes pour améliorer le tout

### Mercredi 27/11/2019
**Matin**
* Redo des rapport en pdf avec modif volcano plot (log base 10)
* SeqMiner comparaison K27ac overtime chez Q140 et WT, screen
* Todo: binom test répartition chaque cluster avant et après all gènes (mais pas recouvrement intégrale donc ?)
* Réorganise les figures
* Ontologie de chaques cluster d'interacteurs

**Après-Midi**
* test répartitien inégale dans les cluster
* analyse de profil acétylation 
* analyse read / gene (peak) chip-seq -> RNAseq over time

### Jeudi 28/11/2019
**Matin** 
* sortie des density value et replotting des profiles sur R
* Test de Kolmogorov-Smirnov pour déterminer profil différent
* Création de l'auto volcano plot script

**Après-midi**
