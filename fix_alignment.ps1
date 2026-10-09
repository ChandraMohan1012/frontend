$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$screens = Get-ChildItem (Join-Path $scriptDir "lib\screens") -Filter "result_*.dart"
foreach ($screen in $screens) {
  $c = Get-Content $screen.FullName -Raw
  $c = $c -replace 'crossAxisAlignment:\s*CrossAxisAlignment\.baseline,\s*textBaseline:\s*TextBaseline\.alphabetic,', 'crossAxisAlignment: CrossAxisAlignment.center,'
  
  if ($screen.Name -eq "result_vastu_score_screen.dart") {
    $c = $c -replace "Text\('/100', style: GoogleFonts\.inter\(fontSize: 20, color: const Color\(0xFF5E5E5E\)\)\)", "Padding(padding: const EdgeInsets.only(top: 36), child: Text('/100', style: GoogleFonts.inter(fontSize: 20, color: const Color(0xFF5E5E5E))))"
  }
  
  Set-Content $screen.FullName $c -NoNewline
}
Write-Host "Fixed baselines"
