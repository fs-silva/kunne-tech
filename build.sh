#!/bin/sh
# Gera public/, a versão hospedável do site, a partir de index.html.
# index.html fica sem <html>/<head>/<body> porque também é publicado como
# Artifact, que monta esse esqueleto sozinho; aqui o esqueleto é posto à mão.
set -e
cd "$(dirname "$0")"

SITE="https://kunnetech.com.br"
mkdir -p public/patente/privacidade public/groupiz/privacidade public/groupiz/excluir-conta public/unhappy-harvest/privacidade

# tudo antes do <header> vai para o <head>; o resto é o corpo
corte=$(grep -n '<header class="top">' index.html | head -1 | cut -d: -f1)

{
  cat <<EOF
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<link rel="canonical" href="$SITE/">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<meta property="og:type" content="website">
<meta property="og:title" content="Kunne Tech">
<meta property="og:description" content="Estúdio de desenvolvimento de apps, jogos e consultoria em tecnologia.">
<meta property="og:url" content="$SITE/">
<meta property="og:locale" content="pt_BR">
EOF
  head -n $((corte - 1)) index.html
  echo '</head>'
  echo '<body>'
  tail -n +"$corte" index.html
  echo '</body>'
  echo '</html>'
} > public/index.html

cp ../patente/privacidade/index.html public/patente/privacidade/index.html
cp ../quiz-em-grupo/site/privacidade/index.html public/groupiz/privacidade/index.html
cp ../quiz-em-grupo/site/excluir-conta/index.html public/groupiz/excluir-conta/index.html
cp ../colheita-infeliz/privacidade/index.html public/unhappy-harvest/privacidade/index.html

echo "kunnetech.com.br" > public/CNAME

cat > public/favicon.svg <<'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="-1 -1 7 9" shape-rendering="crispEdges"><rect x="-1" y="-1" width="7" height="9" fill="#0F1A2C"/><g fill="#7B91FF"><rect x="0" y="0" width="1" height="7"/><rect x="4" y="0" width="1" height="1"/><rect x="3" y="1" width="1" height="1"/><rect x="2" y="2" width="1" height="1"/><rect x="1" y="3" width="1" height="1"/><rect x="2" y="4" width="1" height="1"/><rect x="3" y="5" width="1" height="1"/></g><rect x="4" y="6" width="1" height="1" fill="#FFC23A"/></svg>
EOF

# Vendedores autorizados de anúncios dos apps da Kunne Tech (Google AdMob). Verificado pelo AdMob
# no site cadastrado como site do desenvolvedor na Google Play.
cat > public/app-ads.txt <<'EOF'
google.com, pub-3994076046772375, DIRECT, f08c47fec0942fa0
EOF

cat > public/robots.txt <<EOF
User-agent: *
Allow: /
Sitemap: $SITE/sitemap.xml
EOF

cat > public/sitemap.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>$SITE/</loc></url>
  <url><loc>$SITE/patente/privacidade/</loc></url>
  <url><loc>$SITE/groupiz/privacidade/</loc></url>
  <url><loc>$SITE/groupiz/excluir-conta/</loc></url>
  <url><loc>$SITE/unhappy-harvest/privacidade/</loc></url>
</urlset>
EOF

cat > public/404.html <<'EOF'
<!doctype html>
<html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Página não encontrada · Kunne Tech</title>
<style>body{margin:0;min-height:100vh;display:grid;place-items:center;background:#0B1222;color:#E7ECF6;font:16px/1.5 system-ui,sans-serif;text-align:center;padding:16px}a{color:#FFC23A}h1{font-size:2.4rem;margin:0 0 8px}</style>
</head><body><div><h1>GAME OVER</h1><p>Esta página não existe.</p><p><a href="/">Voltar ao início</a></p></div></body></html>
EOF

echo "public/ pronto"
