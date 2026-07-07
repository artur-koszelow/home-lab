:log info "START: Checking for updates...";
/system/package/update/check-for-updates;
:delay 15s;

:local updateStatus [/system/package/update/get status];

:if ($updateStatus = "New version is available") do={
    :log warning "New version found! Will update after saving logs.";
} else={
    :log info "System is up to date.";
}

# Run log archival BEFORE we potentially reboot the router
/system/script/run zapis_wczorajszych_logow

# Install update if available (router will reboot automatically)
:if ($updateStatus = "New version is available") do={
    :log warning "Starting update install...";
    /system/package/update/install;
}
