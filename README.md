# Terza parte MTIA
Third project of Methods and Tools for Industrial Automation


## Testo esercizio

Sia data una base di carico di prodotti petroliferi e diversi punti vendita (distributori). Si richiede di predire per ciascun punto vendita il giorno in cui verrà effettuato l’ordine, di quale prodotto. Validazione su base di carico di Fiorenzuola.
## Obiettivo
Avendo gli ordini effettuati dalle stazioni di servizio di Fiorenzuola degli anni 2016, 2017 e 2018. Impostiamo una rete neurale che utilizza i dati del 2016 come __training__ del 2017 come __validation__ e del 2018 come __testing__. Questo ci darà una predizione dei dati del 2018, i quali verranno confrontati con i veri dati del 2018 andando a misurare l’errore commesso: utilizzeremo come valutazione lo scarto quadratico medio.

