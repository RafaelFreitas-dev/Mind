# Imprime o id do device que o app deve usar:
# um Android conectado, se houver; senao "chrome".
try {
    $devices = flutter devices --machine 2>$null | ConvertFrom-Json
    $android = $devices | Where-Object { $_.targetPlatform -like '*android*' } | Select-Object -First 1
    if ($android) { $android.id } else { 'chrome' }
} catch {
    'chrome'
}
