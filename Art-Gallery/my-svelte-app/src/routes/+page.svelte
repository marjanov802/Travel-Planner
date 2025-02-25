<script>
    import { onMount } from "svelte";

    const danbullockCount = 15;
    const juliocesartCount = 7;
    const mariaguimaraesCount = 7;

    const danbullockImages = Array.from(
        { length: danbullockCount },
        (_, i) => `/images/danbullock/${i + 1}.jpg`,
    );
    const juliocesartImages = Array.from(
        { length: juliocesartCount },
        (_, i) => `/images/juliocesart/${i + 1}.jpg`,
    );
    const mariaguimaraesImages = Array.from(
        { length: mariaguimaraesCount },
        (_, i) => `/images/mariaguimaraes/${i + 1}.jpg`,
    );

    const artworks = [
        ...danbullockImages,
        ...juliocesartImages,
        ...mariaguimaraesImages,
    ];

    let shuffledArtworks = artworks;

    function shuffleArray(array) {
        let currentIndex = array.length,
            randomIndex;
        while (currentIndex !== 0) {
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex--;
            [array[currentIndex], array[randomIndex]] = [
                array[randomIndex],
                array[currentIndex],
            ];
        }
        return array;
    }

    onMount(() => {
        shuffledArtworks = shuffleArray([...artworks]);
    });
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

<!-- Grid -->
<div class="masonry">
    {#each shuffledArtworks as artwork}
        <div class="masonry-item">
            <a href={"/artwork?src=" + encodeURIComponent(artwork)}>
                <div class="image-container">
                    <img src={artwork} alt="Artwork" />
                    <div class="overlay">View</div>
                </div>
            </a>
        </div>
    {/each}
</div>

<style>
    :global(body) {
        margin: 0;
        font-family: Arial, sans-serif;
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
    .nav-link {
        text-decoration: none;
        color: inherit;
        transition: color 0.2s;
    }
    .nav-link:hover {
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

    .masonry {
        column-count: 5;
        column-gap: 16px;
        padding: 16px;
    }
    .masonry-item {
        break-inside: avoid;
        margin-bottom: 16px;
    }
    .image-container {
        position: relative;
        overflow: hidden;
        border-radius: 8px;
    }
    .image-container img {
        width: 100%;
        height: auto;
        display: block;
        transition: transform 0.3s ease;
    }
    .image-container:hover img {
        transform: scale(1.05);
    }
    .overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.4);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    .image-container:hover .overlay {
        opacity: 1;
    }

    @media (max-width: 1200px) {
        .masonry {
            column-count: 4;
        }
    }
    @media (max-width: 900px) {
        .masonry {
            column-count: 3;
        }
    }
    @media (max-width: 600px) {
        .masonry {
            column-count: 2;
        }
    }
    @media (max-width: 400px) {
        .masonry {
            column-count: 1;
        }
    }
</style>
