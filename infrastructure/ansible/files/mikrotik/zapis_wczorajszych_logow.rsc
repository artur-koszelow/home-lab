# --- Sekcja 1: Ustawienia Daty ---

# Pobierz dzisiejsza date
:local today [/system clock get date];

# --- Sekcja 2: Archiwizacja Logow ---

# Sprawdz, czy zmienna globalna istnieje
:if ([/system script environment find name="LAST_LOG_SAVE_DATE"]="") do={
  :log warning "SKRYPT: Pierwsze uruchomienie. Ustawiam date na jutro"
  :global "LAST_LOG_SAVE_DATE" [/system/clock/get date]
} else={

  # Zmienna istnieje, dzialamy normalnie
  :local lastSavedDate [/system script environment get "LAST_LOG_SAVE_DATE" value];
  :log info ("SKRYPT: Archiwizuje logi dla dnia: " . $lastSavedDate);

  # Stworz nazwe pliku
  :local filename ("log-" . $lastSavedDate . ".txt");

  # Zapisz tylko logi z DNIA WCZORAJSZEGO
  /log print file=("logs/".$filename) where time~($lastSavedDate);
  :delay 5s;
  :log info ("SKRYPT: Logi zapisane do pliku " . $filename);
}

# Zaktualizuj zmienna globalna na dzisiaj (na potrzeby jutrzejszego uruchomienia)
:log info ("SKRYPT: Aktualizuje date ostatniego zapisu na: " . $today);
:global "LAST_LOG_SAVE_DATE" [/system/clock/get date]
