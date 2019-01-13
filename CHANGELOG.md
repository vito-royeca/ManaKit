**Version 4.0.5** @ 13.01.2019
- Updated the Scryfall database to: 2019-01-12 09:23 UTC.

**Version 4.0.4** @ 11.01.2019
- Refactor: ManaKit card and set methods to CMCard and CMSet.
- Updated the Scryfall database to: 2019-01-11 10:09 UTC.

**Version 4.0.3** @ 10.01.2019
- Refactor: Now using v1.9.0 TCGPlayer API.
- Updated the Scryfall database to: 2019-01-09 09:45 UTC.

**Version 4.0.2** @ 04.01.2019
- Updated the Scryfall database to: 2019-01-04 09:58 UTC.

**Version 4.0.1** @ 02.01.2019
- Updated the Scryfall database to: 2019-01-02 09:35 UTC.

**Version 4.0.0** @ 01.01.2019
- Refactor: replaced Core Data with Realm database.

**Version 3.11.2** @ 20.12.2018
- Refactored Manakit.downloadImage(ofCard card:imageType:faceOrder:) with a helper method downloadImage(url:).

**Version 3.11.1** @ 18.12.2018
- Fixed CMCard.firebaseID for special characters: .$[]#/

**Version 3.11.0** @ 12.12.2018
- Fixed CMCard.firebaseID for card with variations.

**Version 3.10.9** @ 09.12.2018
- Updated the Scryfall database to: 2018-12-11 09:21 UTC.

**Version 3.10.8** @ 09.12.2018
- Updated the Scryfall database to: 2018-12-09 09:23 UTC.
- Fixed CMCard.firebaseID value.

**Version 3.10.7** @ 08.12.2018
- Updated the Scryfall database to: 2018-12-08 10:05 UTC.
- Fixed CMCard.myType value.

**Version 3.10.6** @ 07.12.2018
- Updated the Scryfall database to: 2018-12-07 09:32 UTC.
- Added CMCard.frameEffect and CMCard.myType properties.

**Version 3.10.5** @ 05.12.2018
- Updated the Scryfall database to: 2018-12-04 09:24 UTC.
- fix: Card.displayName for cards with faces.

**Version 3.10.4** @ 03.12.2018
- Updated the Scryfall database to: 2018-12-02 09:29 UTC.
- Can now rotate and flip cards with flip, planar, double-faced-token, and transform layouts.

**Version 3.10.3** @ 01.12.2018
- Updated the Scryfall database to: 2018-11-30 09:48 UTC.
- Removed Manakit.croppedImage method.

**Version 3.10.2** @ 28.11.2018
- Updated the Scryfall database to: 2018-11-28 09:40 UTC.
- Added new property: CMCard.displayName.

**Version 3.10.1** @ 16.11.2018
- Updated the Scryfall database to: 2018-11-16 09:24 UTC.

**Version 3.10.0** @ 11.11.2018
- Fixed card rulings.
- Scryfall database update.

**Version 3.0.6** @ 07.11.2018
- Fixed myYearSection and urlString of imageURIs.

**Version 3.0.5** @ 06.11.2018
- No longer builds the variations and other printings in the Scryfall database.

**Version 3.0.4** @ 04.11.2018
- Added foreign language cards in Scryfall database.

**Version 3.0.3** @ 02.11.2018
- Added Rulings and Comprehensive Rules in Scryfall database.

**Version 3.0.2** @ 31.10.2018
- Scryfall database minor fixes.

**Version 3.0.0** @ 29.10.2018
- Now using Scryfall database.

**Version 2.8.6** @ 19.10.2018
- Fixed error in ManaKit.copyDatabaseFiles().
- Updated the Comprehensive Rules to: 20181005.

**Version 2.8.4** @ 18.10.2018
- Updated to Swift 4.2
- Fixed imageURIs and loading of some images.

**Version 2.8.1** @ 12.10.2018
- Deletes cached images when new Core Data database is updated.

**Version 2.8.0** @ 11.10.2018
- refactor: removed DATASource and DATAStack pods.
- fix: Missing images of cards without imageURIs.
- Added CMCollection model.
- UISearchController no longer clears on cancel.

**Version 2.7.9** @ 27.09.2018
- Fixed Scryfall image URIs.

**Version 2.7.8** @ 27.09.2018
- Updated MTGJSON to v3.19.2.

**Version 2.7.7** @ 22.09.2018
- Fixed Manakit.setupResources() .

**Version 2.7.5** @ 21.09.2018
- Set and Sets refactored to MVVM.

**Version 2.7.4** @ 07.09.2018
- Refactored from MVC to MVVM.

**Version 2.7.3** @ 24.08.2018
- Added User, Deck, and List managed objects.

**Version 2.7.2** @ 13.08.2018
- Updated the SQLite database to MTGJSON version 3.19.1

**Version 2.7.1** @ 08.08.2018
- SQlite database file is back to Documents directory.

**Version 2.7.0** @ 01.08.2018
- Refactored to use namespaces.

**Version 2.6.9** @ 23.07.2018
- Updated Keyrune to v3.2.2.

**Version 2.6.5** @ 14.07.2018
- Refactor: now using card as CMCard instead of objectID.
- Optimized loading of CardTableViewCell.

**Version 2.6.3** @ 12.07.2018
- Updated the Timespiral Timeshifted (TSB) set icon.

**Version 2.6.2** @ 08.07.2018
- Fixed downloading TCGPlayer pricing.

**Version 2.6.1** @ 08.07.2018
- Fixed downloading of images.

**Version 2.6.0** @ 07.07.2018
- Updated the SQLite database to MTGJSON version 3.18.

**Version 2.5.4** @ 25.06.2018
- Refactored Core Data to use managed object IDs.

**Version 2.5.2** @ 24.06.2018
- Refactored Core Data to use background thread in saving.

**Version 2.5.1** @ 21.06.2018
- Now using Swift "guard" code
- Mana Cost in CardTableViewCel is now rendered via NSAttributedString.

**Version 2.4.4** @ 17.06.2018
- Fixed warning: automatically Adjusts Font requires using a Dynamic Type text style.

**Version 2.4.3** @ 17.06.2018
- Fixed error: use of undeclared type 'CMSupplier'.

**Version 2.4.2** @ 17.06.2018
- Added property: CMCard.suppliers for TCGPlayer Store Pricing API
- Updated the SQLite database to MTGJSON version 3.17

**Version 2.4.1** @ 16.06.2018
- Changed the color of card pricing in CardTableViewCell.

**Version 2.4.0** @ 12.06.2018
- Added CMCard.ratings property.

**Version 2.3.9** @ 10.06.2018
- Fixed Scryfall number of split cards.

**Version 2.3.8** @ 10.06.2018
- Now returns rounded corner card images.

**Version 2.3.7** @ 09.06.2018
- Updated the SQLite database to MTGJSON version 3.16.

**Version 2.3.6** @ 01.06.2018
- Added support for Scryfall images.

**Version 2.3.5** @ 01.06.2018
- Added values to CMCard.names_.

**Version 2.3.4** @ 01.06.2018
- Downloading and displaying image is now in background thread in CardTableViewCell.

**Version 2.3.3** @ 29.05.2018
- Merged entity CMGlossary to CMRule.

**Version 2.3.2** @ 27.05.2018
- Fixed error when fetching TCG Pricing sor online-only sets.

**Version 2.3.1** @ 26.05.2018
- Minor code fix

**Version 2.3.0** @ 26.05.2018
- New Comrprehensice Rules: April 27, 2018
- New Basic Rules PDF

**Version 2.2.9** @ 22.05.2018
- Refactored CMRule and CMGlosary data.

**Version 2.2.8** @ 22.05.2018
- Readded CMRule and CMGlosary data.

**Version 2.2.7** @ 22.05.2018
- fix: Updating of SQLite database.
- refactor: Updated the CMCard.id value.

**Version 2.2.6** @ 22.05.2018

- Added CMArtist.lastName and CMArtist.firstName properties.
- Fixed loading of mana symbols in CardTableViewCell.
- Added $ symbol in CardTableViewCell.

**Version 2.2.5** @ 21.05.2018

- Added CMArtist.nameSection property.

**Version 2.2.4** @ 18.05.2018

- Renamed the mana image names

**Version 2.2.3** @ 18.05.2018

- Added add and remove Annotation methods to CardTableViewCell
- Fixed pricing label layout in CardTableViewCell
- Now using SDWebImage to cache image downloads

**Version 2.2.2** @ 30.04.2018

- Updated the SQLite database to MTGJSON version 3.15.2.
- Now using PromiseKit.
- Now getting images from Gatherer instead of magiccards.info.
- Removed the Pods directory. Now only maintaining Podfile and Podfile.lock.

**Version 2.2.1** @ 28.12.2017

- Updated the SQLite database to MTGJSON version 3.13.1.

**Version 2.1.1** @ 28.12.2017

- Removed KXHtmlLabel pod.

**Version 2.1.0** @ 25.12.2017

- Replaced set images with Keyrune font.

**Version 2.0.0** @ 06.11.2017

- Added TCGPlayer Hi-Mid-Low X3 pricing.
- Redesign the CardTableViewCell to show TCGPlayer pricing.

**Version 1.1.0** @ 03.11.2017

- Cocoapod updates.

**Version 1.0.0** @ 15.10.2017

- Updated the SQLite database to MTGJSON version 3.11.7.

**Version 0.9.7** @ 06.09.2017

- Updated the SQLite database to MTGJSON version 3.11.5.

**Version 0.9.6** @ 09.08.2017

- Updated the SQLite database to MTGJSON version 3.11.3.

**Version 0.9.5** @ 07.08.2017

- Added CMFormat.nameSection property.

**Version 0.9.4** @ 07.08.2017

- Rebuilt the CMRule and CMGlossary managed objects.

**Version 0.9.3** @ 06.08.2017

- Added CMRule and CMGlossary managed objects.

**Version 0.9.1** @ 04.08.2017

- Added CMCard.numberOrder property.

**Version 0.9.0** @ 01.08.2017

- Fixed the width of 100 and 1000000 mana symbols in HTML code.

**Version 0.8.9** @ 01.08.2017

- Added the Infinity mana symbol.

**Version 0.8.8** @ 01.08.2017

- Optimized the unpacking of image symbols.

**Version 0.8.7** @ 01.08.2017

- Refactored SymbolName enum to dictionary.
- Added method: symbolHTML(name: String) -> String? .

**Version 0.8.6** @ 01.08.2017

- Added SymbolName enum.

**Version 0.8.5** @ 31.07.2017

- Added Card number in CardTableViewCell, after the set name.

**Version 0.8.4** @ 31.07.2017

- Updated the SQLite database to MTGJSON version 3.11.2.

**Version 0.8.3** @ 27.07.2017

- Added notification if card image is downloaded.

**Version 0.8.2** @ 27.07.2017

- feat: Updated the SQLite database to MTGJSON version 3.10.5.

**Version 0.8.0** @ 24.07.2017

- feat: Updated the SQLite database to MTGJSON version 3.10.0.

**Version 0.7.3** @ 22.07.2017

- feat: Added CMSet and CMCard sections.

**Version 0.7.2** @ 21.07.2017

- fix: Loading of bundle resources.

**Version 0.7.1** @ 21.07.2017

- feat: Updated the SQLIte database to MTGJSON version 3.9.3.

**Version 0.6.0** @ 20.07.2017

- refactor: Now using asset catalogue for mana symbols.

**Version 0.5.0** @ 19.07.2017

- refactor: Now using asset catalogue for Set symbols.

**Version 0.4.0** @ 18.07.2017

- Recreated the pod library from CardMagusKit.

**Version 0.1.0** @ 18.07.2017

- Initial release.
 
