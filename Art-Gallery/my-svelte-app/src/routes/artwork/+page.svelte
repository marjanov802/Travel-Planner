<script>
    import { page } from "$app/stores";

    let danbullockImages = Array.from(
        { length: 15 },
        (_, i) => `/images/danbullock/${i + 1}.jpg`,
    );
    let juliocesartImages = Array.from(
        { length: 7 },
        (_, i) => `/images/juliocesart/${i + 1}.jpg`,
    );
    let mariaguimaraesImages = Array.from(
        { length: 7 },
        (_, i) => `/images/mariaguimaraes/${i + 1}.jpg`,
    );

    let artworkSrc = "";
    let artistName = "";
    let similarWorks = [];
    let artistWorks = [];

    $: {
        const urlParams = new URLSearchParams($page.url.search);
        artworkSrc = decodeURIComponent(urlParams.get("src") || "");

        if (artworkSrc.includes("danbullock")) {
            artistName = "Dan Bullock";
            artistWorks = danbullockImages
                .filter((img) => img !== artworkSrc)
                .slice(0, 4);
            similarWorks = [
                ...juliocesartImages,
                ...mariaguimaraesImages,
            ].slice(0, 3);
        } else if (artworkSrc.includes("juliocesart")) {
            artistName = "Julio Cesart";
            artistWorks = juliocesartImages
                .filter((img) => img !== artworkSrc)
                .slice(0, 4);
            similarWorks = [...danbullockImages, ...mariaguimaraesImages].slice(
                0,
                3,
            );
        } else if (artworkSrc.includes("mariaguimaraes")) {
            artistName = "Maria Guimaraes";
            artistWorks = mariaguimaraesImages
                .filter((img) => img !== artworkSrc)
                .slice(0, 4);
            similarWorks = [...danbullockImages, ...juliocesartImages].slice(
                0,
                3,
            );
        }
    }

    function addToCart() {
        alert("Added to cart!");
    }

    function exploreArtist() {
        const slug = artistName.toLowerCase().replace(/\s+/g, "-");
        window.location.href = `/artist/${slug}`;
    }
</script>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="left">
        <h1>Marjanov</h1>
    </div>
    <div class="center">
        <ul>
            <li><a href="/" class="nav-link">Discover</a></li>
            <li><a href="/artist" class="nav-link">Artists</a></li>
        </ul>
    </div>
    <div class="right">
        <div class="basket">
            <span class="basket-icon">🛒</span>
        </div>
    </div>
</nav>

<div class="artwork-container">
    <div class="artwork-content">
        <div class="main-image">
            {#if artworkSrc}
                <img src={artworkSrc} alt="Artwork" />
            {/if}
        </div>

        <div class="artwork-info">
            <h2>{artistName}</h2>
            <p class="artwork-description">Original artwork piece</p>
            <div class="artwork-details">
                <p><strong>Size:</strong> 24" x 36"</p>
                <p><strong>Medium:</strong> Oil on Canvas</p>
                <p><strong>Year:</strong> 2024</p>
            </div>
            <button class="add-to-cart" on:click={addToCart}>
                Add to Cart
            </button>
            <button class="explore-artist" on:click={exploreArtist}>
                Explore Artist
            </button>
        </div>
    </div>
</div>

<div class="related-works">
    <section class="similar-works">
        <h3>Similar Works</h3>
        <div class="works-grid">
            {#each similarWorks as artwork}
                <a
                    href={"/artwork?src=" + encodeURIComponent(artwork)}
                    class="artwork-card"
                >
                    <div class="artwork-image">
                        <img src={artwork} alt="Similar artwork" />
                        <div class="overlay"></div>
                    </div>
                </a>
            {/each}
        </div>
    </section>

    <section class="artist-works">
        <h3>More from {artistName}</h3>
        <div class="works-grid works-grid-4">
            {#each artistWorks as artwork}
                <a
                    href={"/artwork?src=" + encodeURIComponent(artwork)}
                    class="artwork-card"
                >
                    <div class="artwork-image">
                        <img src={artwork} alt="Artist artwork" />
                        <div class="overlay"></div>
                    </div>
                </a>
            {/each}
        </div>
    </section>
</div>

<style>
    :global(body) {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #fff;
        overflow-y: auto;
    }

    .navbar {
        display: flex;
        align-items: center;
        padding: 1rem 2rem;
        border-bottom: 1px solid #ccc;
    }
    .left {
        flex: 1;
    }
    .left h1 {
        margin: 0;
        font-size: 2rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        color: #333;
    }
    .center {
        flex: 1;
        display: flex;
        justify-content: center;
    }
    .center ul {
        list-style: none;
        display: flex;
        gap: 2rem;
        margin: 0;
        padding: 0;
    }
    .center li {
        cursor: pointer;
        font-size: 1rem;
        color: #333;
        transition: color 0.2s;
    }
    .center li:hover {
        color: #000;
    }
    .right {
        flex: 1;
        display: flex;
        justify-content: flex-end;
    }
    .basket {
        width: 24px;
        height: 24px;
        cursor: pointer;
    }
    .basket-icon {
        font-size: 1.5rem;
        line-height: 1;
        display: block;
    }

    .artwork-container {
        max-width: 1200px;
        margin: 2rem auto;
        padding: 0 2rem;
    }
    .artwork-content {
        display: flex;
        gap: 4rem;
        align-items: flex-start;
    }
    .main-image {
        flex: 2;
    }
    .main-image img {
        width: 100%;
        height: auto;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }
    .artwork-info {
        flex: 1;
        padding: 1rem;
    }
    .artwork-info h2 {
        margin: 0 0 1rem;
        font-size: 2rem;
        color: #333;
    }
    .artwork-description {
        color: #666;
        line-height: 1.6;
        margin-bottom: 2rem;
    }
    .artwork-details {
        margin-bottom: 2rem;
    }
    .artwork-details p {
        margin: 0.5rem 0;
        color: #666;
    }
    .add-to-cart,
    .explore-artist {
        background-color: #000;
        color: white;
        border: none;
        padding: 1rem 2rem;
        font-size: 1rem;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
        width: 100%;
        margin-bottom: 1rem;
    }
    .add-to-cart:hover,
    .explore-artist:hover {
        background-color: #333;
    }

    .related-works {
        max-width: 1200px;
        margin: 0 auto 4rem;
        padding: 0 2rem;
    }
    .similar-works,
    .artist-works {
        margin-top: 4rem;
    }
    .similar-works h3,
    .artist-works h3 {
        font-size: 1.5rem;
        color: #333;
        margin-bottom: 1.5rem;
    }
    .works-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 2rem;
    }
    .works-grid-4 {
        grid-template-columns: repeat(4, 1fr);
        gap: 1.5rem;
    }
    .artwork-card {
        text-decoration: none;
        color: inherit;
    }
    .artwork-image {
        position: relative;
        overflow: hidden;
        border-radius: 8px;
        aspect-ratio: 3/4;
    }
    .artwork-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }
    .artwork-image .overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0);
        transition: background 0.3s ease;
    }
    .artwork-card:hover .artwork-image img {
        transform: scale(1.05);
    }
    .artwork-card:hover .artwork-image .overlay {
        background: rgba(0, 0, 0, 0.1);
    }

    /* Responsive Design */
    @media (max-width: 900px) {
        .artwork-content {
            flex-direction: column;
            gap: 2rem;
        }
        .artwork-info {
            padding: 0;
        }
        .works-grid,
        .works-grid-4 {
            grid-template-columns: repeat(2, 1fr);
        }
    }
    @media (max-width: 600px) {
        .artwork-container {
            padding: 0 1rem;
            margin: 1rem auto;
        }
        .artwork-info h2 {
            font-size: 1.5rem;
        }
        .works-grid,
        .works-grid-4 {
            grid-template-columns: 1fr;
        }
        .related-works {
            padding: 0 1rem;
        }
    }
</style>
