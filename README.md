# Four Plates website

The website for Four Plates, at <https://fourplates.app>. Plain HTML and CSS with no build step,
served by GitHub Pages. Rules for changing it are in [AGENTS.md](AGENTS.md).

The pages moved here from the studio site's `four-plates/` folder on 7 November 2026, unchanged
apart from the address details below. This is now the only copy. When the studio site is built, it
links here instead of keeping its own Four Plates pages, and `Website/` in the app's repository is
removed once this site is live.

## Pages

| Page | Address |
| --- | --- |
| Product page | <https://fourplates.app/> |
| How it works | <https://fourplates.app/how-it-works.html> |
| Privacy policy | <https://fourplates.app/privacy.html> |
| Terms of use | <https://fourplates.app/terms.html> |
| Support | <https://fourplates.app/support.html> |

Also `routine-template.csv` and `history-example.csv` (both linked from Support), `404.html`,
`favicon.svg`, `robots.txt`, `sitemap.xml` and `CNAME` (the custom domain for GitHub Pages).

`apple-touch-icon.png` and `social-card.png` (the picture shown when a link is shared) are drawn
by `swift tools/render-images.swift` from the mark's proportions; run it again if the mark
changes, then commit the PNGs. Nothing runs when the site is published.

`screens/` holds the product page's app screenshots as WebP, light and dark, taken from sample
data by the app's own scripts (FitnessApp `docs/app-store.md` § iPhone screenshots). After a new
capture there, run `tools/update-screens.sh` (it needs `cwebp`, from Homebrew's `webp`) and
commit the images.

`history-example.csv` is a made-up two-session history in the layout the app imports. Nothing
tests it automatically: if the app's import rules change, import it into the app again to check.

## Preview

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Then open <http://127.0.0.1:8000/>. Preview `404.html` directly: the Python server shows its own
error page for missing addresses.

The contact address on Privacy, Terms and Support is hello@fourplates.app, an iCloud Mail
address.

## Still to fill before launch

- `APP_STORE_LINK`: on the product page, replace the "Coming to the App Store" placeholder with
  Apple's official badge, unmodified, linked to the listing.

## Publish

1. **GitHub:** create a public repository (for example `fourplates-site`), push `main`, then in
   **Settings › Pages** choose **Deploy from a branch**, **main**, **/ (root)**. GitHub reads the
   custom domain from `CNAME`.
2. **Verify the domain with GitHub first**, so nobody else can point a repository at it: your
   GitHub **Settings › Pages › Add a domain**, enter `fourplates.app`, and add the TXT record it
   gives you in Cloudflare.
3. **Cloudflare, fourplates.app:**
   - Turn off the landing page: **Domain Registration › Manage domains › fourplates.app › Manage ›
     Configuration › Landing Page › Disable**. Cloudflare won't take website records until it's
     off.
   - Leave iCloud's mail records alone (MX, the `apple-domain` and SPF TXT records, and the
     `sig1._domainkey` CNAME).
   - Add these records, all set to **DNS only** (grey cloud) so GitHub can issue the certificate:

     | Type | Name | Content |
     | --- | --- | --- |
     | A | `@` | `185.199.108.153` |
     | A | `@` | `185.199.109.153` |
     | A | `@` | `185.199.110.153` |
     | A | `@` | `185.199.111.153` |
     | AAAA | `@` | `2606:50c0:8000::153` |
     | AAAA | `@` | `2606:50c0:8001::153` |
     | AAAA | `@` | `2606:50c0:8002::153` |
     | AAAA | `@` | `2606:50c0:8003::153` |
     | CNAME | `www` | `mat-0-py.github.io` |

4. **HTTPS:** .app addresses only open over HTTPS, so the site won't load until GitHub has issued
   its certificate (usually within an hour). Then tick **Enforce HTTPS** in the repository's Pages
   settings.
5. **Check** every page, the 404 page at a made-up address, and that fourplates.co.uk and
   www.fourplates.co.uk forward here.

## App Store URLs

Once the site is live: support `https://fourplates.app/support.html`, marketing
`https://fourplates.app/`, privacy policy `https://fourplates.app/privacy.html`, and terms
`https://fourplates.app/terms.html`.
