$ErrorActionPreference = "Stop"
$dir = "C:\Users\ssbra\Desktop\homers_web"

# 1. Update sitemap.xml
$sitemapPath = Join-Path $dir "sitemap.xml"
$sitemapText = [System.IO.File]::ReadAllText($sitemapPath, [System.Text.UTF8Encoding]::new($false))
# Normalize line endings
$sitemapText = $sitemapText -replace "`r`n", "`n"

$targetCuanto = @"
  <url>
    <loc>https://steelframingec.com/cuanto-cuesta-construir-en-ecuador/</loc>
    <lastmod>2026-10-10</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>
"@ -replace "`r`n", "`n"

$diagnosticoBlock = @"
  <url>
    <loc>https://steelframingec.com/diagnostico-proyecto/</loc>
    <lastmod>2026-10-10</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.80</priority>
  </url>
"@ -replace "`r`n", "`n"

if ($sitemapText.Contains($targetCuanto)) {
    $sitemapText = $sitemapText.Replace($targetCuanto, "$targetCuanto`n$diagnosticoBlock")
    Write-Host "Inserted diagnostico-proyecto successfully."
} else {
    Write-Error "Target cuanto-cuesta not found in sitemap.xml"
}

$targetQueEs = @"
  <url>
    <loc>https://steelframingec.com/que-es-steel-framing/</loc>
    <lastmod>2026-10-10</lastmod>
    <changefreq>weekly</changefreq>
    <priority>0.9</priority>
  </url>
"@ -replace "`r`n", "`n"

$funnelBlocks = @"
  <url>
    <loc>https://steelframingec.com/gracias-cita-confirmada/</loc>
    <lastmod>2026-10-10</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.80</priority>
  </url>
  <url>
    <loc>https://steelframingec.com/guia-descargada/</loc>
    <lastmod>2026-10-10</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.80</priority>
  </url>
"@ -replace "`r`n", "`n"

if ($sitemapText.Contains($targetQueEs)) {
    $sitemapText = $sitemapText.Replace($targetQueEs, "$targetQueEs`n$funnelBlocks")
    Write-Host "Inserted gracias-cita-confirmada and guia-descargada successfully."
} else {
    Write-Error "Target que-es-steel-framing not found in sitemap.xml"
}

# Verify sitemap loc count
$locs = [regex]::Matches($sitemapText, "<loc>")
Write-Host "Total sitemap URLs: $($locs.Count)"

# Convert back to CRLF if needed or keep LF (UTF-8 without BOM)
[System.IO.File]::WriteAllText($sitemapPath, $sitemapText, [System.Text.UTF8Encoding]::new($false))

# 2. Update llms.txt and llms-full.txt
foreach ($filename in @("llms.txt", "llms-full.txt")) {
    $filePath = Join-Path $dir $filename
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.UTF8Encoding]::new($false))
    
    $content = $content -replace "Directorio Canónico Completo \(\d+ URLs canónicas\)", "Directorio Canónico Completo (69 URLs canónicas)"
    $content = $content -replace "Directorio Can\u00f3nico Completo \(\d+ URLs can\u00f3nicas\)", "Directorio Canónico Completo (69 URLs canónicas)"
    
    $targetPilares = "### Pilares Comerciales y Técnicos"
    $funnelListItems = @"
### Pilares Comerciales y Técnicos
- [Paso 2: Diagnóstico pericial y agendamiento](https://steelframingec.com/diagnostico-proyecto/): Diagnóstico técnico y agendamiento de consulta pericial para proyectos.
- [Confirmación de Cita Técnica](https://steelframingec.com/gracias-cita-confirmada/): Página de confirmación y detalles de la cita técnica agendada.
- [Entrega de Guía Inicial](https://steelframingec.com/guia-descargada/): Descarga de guía técnica especializada para prospectos en fase inicial.
"@
    
    if ($content.Contains($targetPilares) -and -not $content.Contains("diagnostico-proyecto")) {
        $content = $content.Replace($targetPilares, $funnelListItems)
        Write-Host "Added funnel items to $filename"
    }
    
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.UTF8Encoding]::new($false))
}

Write-Host "All files updated successfully with UTF-8 without BOM."
