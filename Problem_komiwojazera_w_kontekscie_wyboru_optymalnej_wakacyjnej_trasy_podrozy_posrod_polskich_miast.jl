# Instalacja pakietów
using Pkg
#Pkg.add("AntColony")
#Pkg.add("Plots")

# Importowanie pakietów

using AntColony
using Plots

# Definicja macierzy odległości
macierz_odleglosci_miast = [
    0    389  378  603  485  363  477  260  322  222  507  491  430  656  347  188  532  601; # odległość Białystok
    389  0    167  214  391  348  430  421  205  217  318  129  516  267  46   255  265  259; # odległość Bydgoszcz
    378  167  0    315  545  483  565  500  340  156  485  296  642  348  181  339  432  411; # odległość Gdańsk
    603  214  315  0    454  480  529  594  341  431  354  129  643  105  260  439  266  109; # odległość Gorzów Wlkp.
    485  391  545  454  0    156  75   323  196  479  113  335  244  561  364  297  199  365; # odległość Katowice
    363  348  483  480  156  0    114  167  143  394  220  354  163  585  307  181  300  422; # odległość Kielce
    477  430  565  529  75   114  0    269  220  500  182  403  165  634  384  295  268  427; # odległość Kraków
    260  421  500  594  323  167  269  0    242  370  382  465  170  683  375  161  428  542; # odległość Lublin
    322  205  340  341  196  143  220  242  0    281  181  212  306  446  159  134  204  303; # odległość Łódź
    222  217  156  431  479  394  500  370  281  0    452  323  516  484  177  213  442  453; # odległość Olsztyn
    507  318  485  354  113  220  182  382  181  452  0    261  347  459  312  319  86   245; # odległość Opole
    491  129  296  129  335  354  403  465  212  323  261  0    517  234  151  310  178  130; # odległość Poznań
    430  516  642  643  244  163  165  170  306  516  347  517  0    751  470  303  433  585; # odległość Rzeszów
    656  267  348  105  561  585  634  683  446  484  459  234  751  0    313  524  371  214; # odległość Szczecin
    347  46   181  260  364  307  384  375  159  177  312  151  470  313  0    209  279  281; # odległość Toruń
    188  255  339  439  297  181  295  161  134  213  319  310  303  524  209  0    344  413; # odległość Warszawa
    532  265  432  266  199  300  268  428  204  442  86   178  433  371  279  344  0    157; # odległość Wrocław
    601  259  411  109  365  422  427  542  303  453  245  130  585  214  281  413  157  0    # odległość Zielona Góra
]

# Uruchamia algorytm ACO
sciezka_mrowki = aco(
                macierz_odleglosci_miast, 
                start_node=16, 
                end_node=3, 
                is_tour=false, 
                beta=1, 
                rho=0.1,
                q=0.1, 
                Q=1, 
                tau_min=1.0, 
                tau_max=5.0, 
                max_iter=20, 
                reset_iter=10,
                top_perc_ants=0.05, 
                verbose=true)

# Oblicza całkowitą odległość dla ścieżki
calkowita_odleglosc = sum(macierz_odleglosci_miast[sciezka_mrowki[i], sciezka_mrowki[i+1]] for i in 1:length(sciezka_mrowki)-1)

# Liczba miast do odwiedzenia
miasta = [
            "Białystok", "Bydgoszcz", "Gdańsk", 
            "Gorzów Wlkp.", "Katowice", "Kielce", 
            "Kraków", "Lublin", "Łódź", "Olsztyn", 
            "Opole", "Poznań", "Rzeszów", "Szczecin", 
            "Toruń", "Warszawa", "Wrocław", "Zielona Góra"
        ]

# Położenie geograficzne miast
polozenie_miast = [
    (53.132488, 23.168840),   # Białystok
    (53.123480, 18.008438),   # Bydgoszcz
    (54.352025, 18.646638),   # Gdańsk
    (52.732097, 15.236571),   # Gorzów Wlkp.
    (50.264892, 19.023782),   # Katowice
    (50.866077, 20.628567),   # Kielce
    (50.061947, 19.936856),   # Kraków
    (51.246453, 22.568446),   # Lublin
    (51.759248, 19.455983),   # Łódź
    (53.779959, 20.494184),   # Olsztyn
    (50.675845, 17.921290),   # Opole
    (52.406374, 16.925168),   # Poznań
    (50.041187, 21.999121),   # Rzeszów
    (53.430181, 14.550962),   # Szczecin
    (53.013790, 18.598444),   # Toruń
    (52.231923, 21.006726),   # Warszawa
    (51.107883, 17.038538),   # Wrocław
    (51.935621, 15.506208)    # Zielona Góra
]

# Tworzy wykres punktowy miast
scatter(
        [koordynaty[2] for koordynaty in polozenie_miast], 
        [koordynaty[1] for koordynaty in polozenie_miast], 
        legend = false, 
        color = "#e09f3e", 
        markersize = 4, 
        markerstrokewidth = 0.5, 
        xlim = (14.0, 24.0), 
        ylim = (49.5, 54.5))

# Tytuł wykresu
title!("Końcowa ścieżka podróży")

# Tytuły osi
xlabel!("Długość geograficzna")
ylabel!("Szerokość geograficzna")

# Dodanie etykiet do miast
for i in 1:length(miasta)
    annotate!(
                polozenie_miast[i][2], 
                polozenie_miast[i][1], 
                text(miasta[i],
                :black,
                :bottom, 
                :left,
                :auto,
                0
                )
                )
end

# Dodanie linii łączących miasta
for i in 1:(length(sciezka_mrowki) - 1)
    plot!(
        [polozenie_miast[sciezka_mrowki[i]][2], polozenie_miast[sciezka_mrowki[i+1]][2]], 
        [polozenie_miast[sciezka_mrowki[i]][1], polozenie_miast[sciezka_mrowki[i+1]][1]], 
        color = "#023047",
        line = :solid,
        linewidth = 0.5)
end

# Dodanie etykiety z całkowitą odległością
annotate!(
        16.0,
        54.0, 
        text(
            "Całkowita odległość: $calkowita_odleglosc", 
            font(9, "Calibri"))
            )

# Ustawienie rozmiaru wykresu i czcionki
plot!(size=(800, 700), grid=false, fontfamily= "Calibri", 11)

# Wyświetlenie wykresu
plot!()
