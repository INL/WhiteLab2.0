# WhiteLab 2.0
==============

WhiteLab 2.0 is a Ruby on Rails implementation of [WhiteLab](https://github.com/TiCCSoftware/WhiteLab), 
a web application for the search and exploration of large corpora with linguistic annotations.

Main changes in this version:
- The Search page is set as the home page and the original Home page has been moved to Info;
- Admin interface to control contents of the Info page, interface translations, and available metadata;
- Added support for a Neo4J backend comprised of a data importer and search plugin as an alternative to [BlackLab](https://github.com/INL/BlackLab) and [BlackLab Server](https://github.com/INL/BlackLab-server);
- Added support for audio. The Neo4J backend allows for playback of fragments matching query hits, while the BlackLab backend only allows for playback of entire files;
- Custom indexers have been created for BlackLab that are suited for importing the SoNaR reference corpus and the CGN corpus, each with their individual metadata formats. Fields have been added to these indexers to allow integration with WhiteLab 2.0 and the use of audio. A WhiteLab 2.0 compatible version of BlackLab is available [here](https://github.com/Taalmonsters/BlackLab).

Installation and configuration
==============================

Instructions on how to install and configure the WhiteLab 2.0 web application and all it's prerequisites can be found [here](docs/install/README.md).

Usage
=====

Instructions regarding the usage of WhiteLab 2.0 can be found [here](docs/usage/README.md).