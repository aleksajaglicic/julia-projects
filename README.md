# OneVsAll Projekat

**OneVsAll** je projekat razvijen u **Juliji**, koji koristi različite biblioteke kao što su **GLM**, **CSV**, **DataFrames**, **Lathe** i **StatsModels** za analizu podataka i primenu mašinskog učenja. Projekat se fokusira na klasifikaciju vrsta drveća na osnovu visine i širine, koristeći podatke iz CSV datoteke. Implementirane su funkcionalnosti za treniranje modela, predviđanje klasa drveta, izračun osetljivosti i preciznosti sistema, kao i rad sa binarnim klasama, matricama konfuzije i statističkim merama.

## Funkcionalnosti

Projekat implementira sledeće funkcionalnosti:

1. **Klasifikacija vrsta drveća**: Na osnovu podataka o visini i širini drveća, projekat koristi **One vs All** metodu klasifikacije za predviđanje vrsta drveća.
2. **Treniranje modela**: Treniranje modela pomoću podataka iz CSV datoteke, koristeći **GLM** (Generalized Linear Models) za kreiranje modela klasifikacije.
3. **Predviđanje klasa**: Korišćenje treniranog modela za predviđanje klase drveća (vrste) na osnovu novih podataka o visini i širini.
4. **Izračun osetljivosti i preciznosti**: Merenje performansi sistema kroz izračunavanje osetljivosti (sensitivity) i preciznosti (precision) modela.
5. **Rad sa binarnim klasama**: Implementacija funkcionalnosti za rad sa binarnim klasama i izračunavanje metrika u ovom kontekstu.
6. **Matrice konfuzije**: Generisanje matrica konfuzije za analizu performansi modela.
7. **Statističke mere**: Korišćenje statističkih mera kao što su preciznost, osetljivost, tačnost i F1 skor za ocenu performansi modela.

## Tehnologije

- **Julija**: Glavni programski jezik za razvoj aplikacije.
- **GLM**: Biblioteka za rad sa generalizovanim linearnim modelima (GLM).
- **CSV**: Biblioteka za rad sa CSV datotekama.
- **DataFrames**: Biblioteka za efikasno upravljanje i analizu podataka u formatu tabela.
- **Lathe**: Biblioteka za implementaciju mašinskog učenja u Juliji.
- **StatsModels**: Biblioteka za primenu statističkih modela i analizu podataka.

## Ključne funkcionalnosti

1. **One vs All Klasifikacija**: Klasifikacija drveća u više klasa na osnovu visine i širine drveća, koristeći One vs All pristup.
2. **Trening modela**: Treniranje modela koristeći podatke o drveću i njihove karakteristike (visina, širina).
3. **Predviđanje klasa**: Predviđanje vrsta drveća na osnovu novih vrednosti visine i širine pomoću prethodno treniranog modela.
4. **Osnovne statističke mere**: Izračunavanje preciznosti, osetljivosti, tačnosti i F1 skora kao mera kvaliteta modela.
5. **Binarne klase i metrika**: Klasifikacija sa binarnim klasama i izračunavanje relevantnih metrika za evaluaciju modela.
6. **Matrica konfuzije**: Korišćenje matrica konfuzije za analizu grešaka klasifikacije.
7. **Rad sa CSV datotekama**: Učitavanje podataka iz CSV datoteka, manipulacija i analiza podataka.

## Instalacija

Da biste pokrenuli projekat na svom računaru, pratite sledeće korake:

### 1. Instalacija Julije

Ako još nemate instaliranu Juliju, preuzmite je sa zvanične stranice: [https://julialang.org/downloads/](https://julialang.org/downloads/)

### 2. Klonirajte repo

Klonirajte repo sa GitHub-a:

```bash
git clone https://github.com/aleksajaglicic/julia-projects.git
cd julia-projects
