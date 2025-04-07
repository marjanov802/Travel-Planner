<script>
    import { page } from "$app/stores";
    import { onMount } from "svelte";

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

    let cartItems = [];
    let cartCount = 0;
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;

    onMount(() => {
        const savedCart = localStorage.getItem("artworkCart");
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
            cartCount = cartItems.length;
        }
    });

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
        const artwork = {
            id: Date.now(),
            src: artworkSrc,
            artist: artistName,
            title: "Original artwork piece",
            size: '24" x 36"',
            medium: "Oil on Canvas",
            year: "2024",
            price: 1200,
        };

        cartItems = [...cartItems, artwork];

        cartCount = cartItems.length;
        localStorage.setItem("artworkCart", JSON.stringify(cartItems));

        lastAddedItem = artwork;

        showAddedNotification = true;

        setTimeout(() => {
            showAddedNotification = false;
        }, 3000);
    }

    function toggleCart() {
        isCartOpen = !isCartOpen;
    }

    function calculateTotal() {
        return cartItems.reduce((total, item) => total + item.price, 0);
    }

    function removeFromCart(id) {
        cartItems = cartItems.filter((item) => item.id !== id);
        cartCount = cartItems.length;
        localStorage.setItem("artworkCart", JSON.stringify(cartItems));
    }

    function exploreArtist() {
        const slug = artistName.toLowerCase().replace(/\s+/g, "-");
        window.location.href = `/artist/${slug}`;
    }
</script>

<nav class="navbar">
    <div class="left">
        <a href="/" class="logo-link">
            <h1>Marjanov</h1>
        </a>
    </div>
    <div class="center">
        <ul>
            <li><a href="/" class="nav-link">Discover</a></li>
            <li><a href="/artist" class="nav-link">Artists</a></li>
        </ul>
    </div>
    <div class="right">
        <div class="basket" on:click={toggleCart}>
            <svg
                class="basket-icon"
                xmlns="http://www.w3.org/2000/svg"
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"
            >
                <circle cx="9" cy="21" r="1"></circle>
                <circle cx="20" cy="21" r="1"></circle>
                <path
                    d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"
                ></path>
            </svg>
            {#if cartCount > 0}
                <span class="cart-count">{cartCount}</span>
            {/if}
        </div>
    </div>
</nav>

{#if showAddedNotification && lastAddedItem}
    <div class="added-notification">
        <div class="notification-content">
            <div class="notification-image">
                <img src={lastAddedItem.src} alt="Added artwork" />
            </div>
            <div class="notification-info">
                <h4>Added to Cart</h4>
                <p>{lastAddedItem.title}</p>
                <p class="notification-artist">by {lastAddedItem.artist}</p>
                <p class="notification-price">
                    £{lastAddedItem.price.toLocaleString()}
                </p>
            </div>
            <button
                class="close-notification"
                on:click={() => (showAddedNotification = false)}>×</button
            >
        </div>
        <div class="notification-actions">
            <button
                class="continue-shopping"
                on:click={() => (showAddedNotification = false)}
            >
                Continue Shopping
            </button>
            <button
                class="view-cart"
                on:click={() => {
                    showAddedNotification = false;
                    isCartOpen = true;
                }}
            >
                View Cart ({cartCount})
            </button>
        </div>
    </div>
{/if}

{#if isCartOpen}
    <div class="cart-overlay" on:click={() => (isCartOpen = false)}></div>
    <div class="cart-sidebar">
        <div class="cart-header">
            <h3>Your Cart ({cartCount})</h3>
            <button class="close-cart" on:click={() => (isCartOpen = false)}
                >×</button
            >
        </div>

        <div class="cart-items">
            {#if cartItems.length === 0}
                <div class="empty-cart">
                    <svg
                        class="empty-cart-icon"
                        xmlns="http://www.w3.org/2000/svg"
                        width="32"
                        height="32"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="1.5"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    >
                        <circle cx="9" cy="21" r="1"></circle>
                        <circle cx="20" cy="21" r="1"></circle>
                        <path
                            d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"
                        ></path>
                    </svg>
                    <p>Your cart is empty</p>
                </div>
            {:else}
                {#each cartItems as item (item.id)}
                    <div class="cart-item">
                        <div class="cart-item-image">
                            <img src={item.src} alt="Cart item" />
                        </div>
                        <div class="cart-item-details">
                            <h4>{item.title}</h4>
                            <p class="item-artist">by {item.artist}</p>
                            <p class="item-size">{item.size}</p>
                            <p class="item-price">
                                £{item.price.toLocaleString()}
                            </p>
                        </div>
                        <button
                            class="remove-item"
                            on:click={() => removeFromCart(item.id)}
                        >
                            ×
                        </button>
                    </div>
                {/each}
            {/if}
        </div>

        {#if cartItems.length > 0}
            <div class="cart-footer">
                <div class="cart-total">
                    <span>Total</span>
                    <span>£{calculateTotal().toLocaleString()}</span>
                </div>
                <button class="checkout-button"> Proceed to Checkout </button>
            </div>
        {/if}
    </div>
{/if}

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
                <p><strong>Price:</strong> £1,200</p>
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
        position: relative;
    }
    .basket-icon {
        width: 24px;
        height: 24px;
        color: #333;
        display: block;
    }
    .cart-count {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: #e53e3e;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 0.75rem;
        font-weight: bold;
    }

    .added-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        width: 320px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        overflow: hidden;
        animation: slideIn 0.3s ease-out;
    }

    @keyframes slideIn {
        0% {
            transform: translateX(100%);
            opacity: 0;
        }
        100% {
            transform: translateX(0);
            opacity: 1;
        }
    }

    .notification-content {
        padding: 15px;
        display: flex;
        position: relative;
    }

    .notification-image {
        width: 70px;
        height: 70px;
        border-radius: 4px;
        overflow: hidden;
        margin-right: 15px;
    }

    .notification-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .notification-info {
        flex: 1;
    }

    .notification-info h4 {
        margin: 0 0 5px;
        color: #333;
    }

    .notification-info p {
        margin: 0 0 3px;
        font-size: 0.9rem;
        color: #666;
    }

    .notification-artist {
        font-size: 0.8rem !important;
        font-style: italic;
    }

    .notification-price {
        font-weight: bold;
        color: #000 !important;
    }

    .close-notification {
        position: absolute;
        top: 10px;
        right: 10px;
        background: none;
        border: none;
        font-size: 1.2rem;
        color: #999;
        cursor: pointer;
    }

    .notification-actions {
        display: flex;
        border-top: 1px solid #eee;
    }

    .continue-shopping,
    .view-cart {
        flex: 1;
        padding: 10px;
        border: none;
        background: none;
        cursor: pointer;
        font-size: 0.85rem;
        transition: background-color 0.2s;
    }

    .continue-shopping {
        border-right: 1px solid #eee;
        color: #666;
    }

    .continue-shopping:hover {
        background-color: #f9f9f9;
    }

    .view-cart {
        background-color: #f8f8f8;
        color: #000;
        font-weight: 500;
    }

    .view-cart:hover {
        background-color: #f0f0f0;
    }

    .cart-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1001;
    }

    .cart-sidebar {
        position: fixed;
        top: 0;
        right: 0;
        width: 350px;
        height: 100%;
        background: white;
        z-index: 1002;
        box-shadow: -4px 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        animation: slideInCart 0.3s ease-out;
    }

    @keyframes slideInCart {
        0% {
            transform: translateX(100%);
        }
        100% {
            transform: translateX(0);
        }
    }

    .cart-header {
        padding: 20px;
        border-bottom: 1px solid #eee;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .cart-header h3 {
        margin: 0;
        font-size: 1.2rem;
    }

    .close-cart {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: #666;
        cursor: pointer;
    }

    .cart-items {
        flex: 1;
        overflow-y: auto;
        padding: 20px;
    }

    .empty-cart {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 200px;
        color: #888;
        text-align: center;
    }

    .empty-cart-icon {
        margin-bottom: 16px;
        color: #aaa;
    }

    .cart-item {
        display: flex;
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #eee;
        position: relative;
    }

    .cart-item-image {
        width: 80px;
        height: 80px;
        border-radius: 4px;
        overflow: hidden;
        margin-right: 15px;
    }

    .cart-item-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .cart-item-details {
        flex: 1;
    }

    .cart-item-details h4 {
        margin: 0 0 5px;
        font-size: 1rem;
    }

    .item-artist {
        margin: 0 0 5px;
        font-size: 0.9rem;
        color: #666;
    }

    .item-size {
        margin: 0 0 5px;
        font-size: 0.8rem;
        color: #888;
    }

    .item-price {
        font-weight: bold;
        font-size: 0.9rem;
        margin: 5px 0 0;
    }

    .remove-item {
        position: absolute;
        top: 0;
        right: 0;
        background: none;
        border: none;
        font-size: 1.2rem;
        color: #999;
        cursor: pointer;
    }

    .remove-item:hover {
        color: #e53e3e;
    }

    .cart-footer {
        padding: 20px;
        border-top: 1px solid #eee;
        background: #f9f9f9;
    }

    .cart-total {
        display: flex;
        justify-content: space-between;
        font-weight: bold;
        margin-bottom: 15px;
    }

    .checkout-button {
        width: 100%;
        padding: 12px;
        background: #000;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .checkout-button:hover {
        background: #333;
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
        .cart-sidebar {
            width: 320px;
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
        .added-notification {
            width: calc(100% - 40px);
            right: 20px;
            left: 20px;
        }
        .cart-sidebar {
            width: 100%;
        }
    }

    .logo-link {
        text-decoration: none;
        color: inherit;
    }

    .nav-link {
        text-decoration: none;
        color: inherit;
    }
</style>
