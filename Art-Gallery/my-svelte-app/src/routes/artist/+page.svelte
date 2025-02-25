<script>
    import { onMount } from "svelte";

    const artists = [
        {
            name: "Dan Bullock",
            bio: "Exploring abstraction and realism through bold colour palettes and dynamic brushstrokes.",
            location: "New York, USA",
            portrait: "/images/danbullock/1.jpg",
            slug: "danbullock",
            style: "Abstract & Realism",
            artworks: [
                {
                    id: 1,
                    title: "Abstract Dawn",
                    price: 1200,
                    image: "/images/danbullock/2.jpg",
                },
                {
                    id: 2,
                    title: "Realism in Motion",
                    price: 1500,
                    image: "/images/danbullock/3.jpg",
                },
            ],
        },
        {
            name: "Julio Cesart",
            bio: "Blending vibrant street culture with modern narratives using traditional techniques.",
            location: "Barcelona, Spain",
            portrait: "/images/juliocesart/1.jpg",
            slug: "juliocesart",
            style: "Street Culture & Modern Narratives",
            artworks: [
                {
                    id: 3,
                    title: "Urban Symphony",
                    price: 900,
                    image: "/images/juliocesart/2.jpg",
                },
                {
                    id: 4,
                    title: "Street Dream",
                    price: 1100,
                    image: "/images/juliocesart/3.jpg",
                },
            ],
        },
        {
            name: "Maria Guimaraes",
            bio: "Delving into human emotions through minimalist expressions and subtle colour transitions.",
            location: "Lisbon, Portugal",
            portrait: "/images/mariaguimaraes/1.jpg",
            slug: "mariaguimaraes",
            style: "Minimalism & Emotional Depth",
            artworks: [
                {
                    id: 5,
                    title: "Serene Lines",
                    price: 800,
                    image: "/images/mariaguimaraes/2.jpg",
                },
                {
                    id: 6,
                    title: "Emotional Hues",
                    price: 950,
                    image: "/images/mariaguimaraes/3.jpg",
                },
            ],
        },
    ];

    let cart = [];

    function exploreArtwork(slug, artworkId) {
        window.location.href = `/artwork?artist=${slug}&id=${artworkId}`;
    }

    function exploreArtist(slug) {
        window.location.href = `/artist/${slug}`;
    }

    function addToCart(artwork) {
        const existingItem = cart.find((item) => item.id === artwork.id);
        if (!existingItem) {
            cart = [...cart, { ...artwork, quantity: 1 }];
        } else {
            cart = cart.map((item) =>
                item.id === artwork.id
                    ? { ...item, quantity: item.quantity + 1 }
                    : item,
            );
        }
        updateCartDisplay();
    }

    function updateCartDisplay() {
        const basketIcon = document.querySelector(".basket-count");
        if (basketIcon) {
            basketIcon.textContent = cart.reduce(
                (total, item) => total + item.quantity,
                0,
            );
        }
    }

    function viewCart() {
        let cartDetails = "Cart Contents:\n";
        cart.forEach((item) => {
            cartDetails += `${item.title} - Quantity: ${item.quantity} - Total: $${item.quantity * item.price}\n`;
        });
        cartDetails += `\nTotal Amount: $${cart.reduce((total, item) => total + item.quantity * item.price, 0)}`;
        alert(cartDetails);
    }
</script>

<nav class="navbar">
    <div class="left">
        <h1>Marjanov</h1>
    </div>
    <div class="center">
        <ul>
            <li><a href="/" class="nav-link">Discover</a></li>
            <li><a href="/artists" class="nav-link active">Artists</a></li>
        </ul>
    </div>
    <div class="right" on:click={viewCart}>
        <div class="basket" title="Cart">
            🛒 <span class="basket-count"
                >{cart.reduce((total, item) => total + item.quantity, 0)}</span
            >
        </div>
    </div>
</nav>

<section class="artist-showcase">
    {#each artists as artist}
        <div class="artist-section">
            <div
                class="artist-image"
                style="background-image: url({artist.portrait});"
            ></div>
            <div class="artist-description">
                <h2>{artist.name}</h2>
                <h3>{artist.style}</h3>
                <p class="location">{artist.location}</p>
                <p>{artist.bio}</p>
                <button
                    class="explore-btn"
                    on:click={() => exploreArtist(artist.slug)}
                >
                    Explore {artist.name}'s Gallery
                </button>
                <div class="artworks">
                    {#each artist.artworks as artwork}
                        <a
                            href={`/artwork?artist=${artist.slug}&id=${artwork.id}`}
                            class="artwork-card"
                        >
                            <img src={artwork.image} alt={artwork.title} />
                            <h4>{artwork.title}</h4>
                            <p>Price: ${artwork.price}</p>
                            <button
                                on:click|stopPropagation={() =>
                                    addToCart(artwork)}>Add to Cart</button
                            >
                        </a>
                    {/each}
                </div>
            </div>
        </div>
    {/each}
</section>

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
        font-weight: bold;
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
    .nav-link:hover,
    .nav-link.active {
        color: #000;
        border-bottom: 2px solid #000;
    }
    .right {
        flex: 1;
        display: flex;
        justify-content: flex-end;
        cursor: pointer;
    }
    .basket {
        font-size: 1.5rem;
        position: relative;
    }
    .basket-count {
        position: absolute;
        top: -10px;
        right: -10px;
        background-color: red;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 0.8rem;
    }

    .artist-showcase {
        max-width: 1200px;
        margin: 3rem auto;
        padding: 0 1rem;
        display: flex;
        flex-direction: column;
        gap: 3rem;
    }

    .artist-section {
        display: flex;
        gap: 2rem;
        background-color: #f4f4f4;
        border-radius: 12px;
        padding: 1rem;
    }

    .artist-image {
        flex: 1;
        height: 350px;
        background-size: cover;
        background-position: center;
    }

    .artist-description {
        flex: 2;
        display: flex;
        flex-direction: column;
    }

    .artworks {
        display: flex;
        gap: 1.5rem;
        margin-top: 1rem;
        flex-wrap: wrap;
    }

    .artwork-card {
        width: 180px;
        background-color: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        text-decoration: none;
        color: inherit;
        text-align: center;
        padding: 1rem;
        cursor: pointer;
    }

    .artwork-card img {
        width: 100%;
        height: 120px;
        object-fit: cover;
        border-radius: 4px;
    }

    .artwork-card button {
        margin-top: 0.5rem;
        width: 100%;
        padding: 0.5rem;
        background-color: #000;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .artwork-card button:hover {
        background-color: #333;
    }
</style>
