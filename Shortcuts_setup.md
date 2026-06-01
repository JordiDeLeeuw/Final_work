## Stappenplan fotokaarten

1. Open de app Apple Shortcuts.

2. Ga naar Automation.

3. Klik rechtsboven op het plus-icoon om een nieuwe automatisering aan te maken.

4. Zoek naar NFC.

5. Scan de NFC-tag van de juiste fotokaart.

6. Geef de tag een duidelijke naam, bijvoorbeeld Depimi, Jiroh of Lebang.

7. Kies voor Run Immediately.

8. Zet de optie voor een melding bij het uitvoeren uit, zodat de automatisering automatisch op de achtergrond loopt.

9. Voeg bij de acties eerst een Text-blok toe.

10. Plaats in het Text-blok de structuur die overeenkomt met de Firestore-database:

json {   "fields": {     "status": {       "stringValue": "unlocked"     }   } } 

11. Voeg daarna een Get Contents of URL-blok toe.

12. Vul in dit blok de juiste Firestore-URL in. Voor Depimi is dit:

text https://firestore.googleapis.com/v1/projects/jidli-948f1/databases/(default)/documents/items/depimi 

Voor de andere fotokaarten wordt achteraan de naam aangepast naar:

text jiroh 

of

text lebang 

13. Open de instellingen van het Get Contents of URL-blok.

14. Zet Method op PATCH.

15. Zet Request Body op File.

16. Kies bij File het Text-blok dat eerder werd aangemaakt.

17. Sla de automatisering op.
