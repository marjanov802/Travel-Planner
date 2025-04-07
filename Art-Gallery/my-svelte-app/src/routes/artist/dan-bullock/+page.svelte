<script>
    import { onMount } from "svelte";

    let navDark = false;
    const backgrounds = [
        "/images/danbullock/background.jpg",
        "/images/danbullock/background2.jpg",
        "/images/danbullock/background4.jpg",
        "/images/danbullock/background3.jpg",
        "/images/danbullock/background5.jpg",
    ];

    let cartItems = [];
    let cartCount = 0;
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;

    function addToCart(artwork) {
        const newItem = {
            id: Date.now(),
            src: artwork,
            quantity: 1,
            price: 1200,
            artist: artist.name,
            title: "Original artwork piece",
        };

        cartItems = [...cartItems, newItem];
        cartCount = cartItems.length;
        localStorage.setItem("artworkCart", JSON.stringify(cartItems));

        lastAddedItem = newItem;
        showAddedNotification = true;

        setTimeout(() => {
            showAddedNotification = false;
        }, 3000);
    }

    function removeFromCart(id) {
        cartItems = cartItems.filter((item) => item.id !== id);
        cartCount = cartItems.length;
        localStorage.setItem("artworkCart", JSON.stringify(cartItems));
    }

    function calculateTotal() {
        return cartItems.reduce((total, item) => total + item.price, 0);
    }

    function toggleCart() {
        isCartOpen = !isCartOpen;
    }

    onMount(() => {
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.target.classList.contains("artworks-screen")) {
                        navDark = entry.isIntersecting;
                    }
                });
            },
            { threshold: 0.5 },
        );
        const galleryScreen = document.querySelector(".artworks-screen");
        if (galleryScreen) {
            observer.observe(galleryScreen);
        }

        const savedCart = localStorage.getItem("artworkCart");
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
            cartCount = cartItems.length;
        }
    });

    const artist = {
        name: "Dan Bullock",
        bio: "Dan Bullock is a contemporary artist renowned for his dynamic brushstrokes and bold color palettes. His work explores the interplay between abstraction and realism.",
        background:
            "Based in New York, his art has been exhibited in galleries around the world.",
        portrait: "/images/danbullock/1.jpg",
    };

    const danbullockCount = 15;
    const artworks = Array.from(
        { length: danbullockCount },
        (_, i) => `/images/danbullock/${i + 1}.jpg`,
    );

    const orderedArtworks = [...artworks.slice(12), ...artworks.slice(0, 12)];

    function chunkArray(array, size) {
        const result = [];
        for (let i = 0; i < array.length; i += size) {
            result.push(array.slice(i, i + size));
        }
        return result;
    }

    const chunkedArtworks = chunkArray(orderedArtworks, 3);
</script>

<nav class="navbar {navDark ? 'dark' : ''}">
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

<div class="scroll-container">
    <section
        class="screen artist-info"
        style:background-image="url({artist.portrait})"
        style:background-position="center center"
        style:background-repeat="no-repeat"
        style:background-size="cover"
    >
        <div class="info-container">
            <div class="text">
                <h2>{artist.name}</h2>
                <p>{artist.bio}</p>
                <p class="background">{artist.background}</p>
            </div>
            <div class="image">
                <img src={artist.portrait} alt="{artist.name} Portrait" />
            </div>
        </div>
    </section>

    {#each chunkedArtworks as row, index (row[0])}
        {#if index !== 1}
            <section
                class="screen artworks-screen"
                style="background: url({backgrounds[
                    index % backgrounds.length
                ]}); background-size: cover;"
            >
                <div class="art-row">
                    {#if index === 2}
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/18.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/9.jpg"
                                alt="Artwork 9"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/6.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/5.jpg"
                                alt="Artwork 5"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/6.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/6.jpg"
                                alt="Artwork 6"
                            />
                        </a>
                    {:else if index === 3}
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/11.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/11.jpg"
                                alt="Artwork 11"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/12.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/12.jpg"
                                alt="Artwork 12"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/7.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/7.jpg"
                                alt="Artwork 7"
                            />
                        </a>
                    {:else if index === 4}
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/16.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/16.jpg"
                                alt="Artwork 16"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/17.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/8.jpg"
                                alt="Artwork 8"
                            />
                        </a>
                        <a
                            href={"/artwork?src=" +
                                encodeURIComponent("/images/danbullock/8.jpg")}
                            class="artwork-card"
                        >
                            <img
                                src="/images/danbullock/17.jpg"
                                alt="Artwork 17"
                            />
                        </a>
                    {:else}
                        {#each row as art}
                            <a
                                href={"/artwork?src=" + encodeURIComponent(art)}
                                class="artwork-card"
                            >
                                <img src={art} alt="{artist.name} artwork" />
                            </a>
                        {/each}
                    {/if}
                </div>
            </section>
        {/if}
    {/each}

    <section
        class="screen contact-artist"
        style="background: url({backgrounds[0]}); background-size: cover;"
    >
        <div class="contact-overlay"></div>
        <div class="contact-container">
            <h2>Contact the Artist</h2>
            <p>
                If you're interested in Dan Bullock's artwork or have inquiries,
                feel free to get in touch.
            </p>
            <form class="contact-form">
                <div class="form-row">
                    <input type="text" placeholder="Your Name" required />
                    <input type="email" placeholder="Your Email" required />
                </div>
                <textarea placeholder="Your Message" rows="5" required
                ></textarea>
                <button type="submit">Send Message</button>
            </form>
        </div>
    </section>
</div>

<style>
    :global(body) {
        margin: 0;
        font-family: Arial, sans-serif;
        background-color: #fff;
        overflow: hidden;
    }

    .navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 80px;
        display: flex;
        align-items: center;
        padding: 0 2rem;
        background: #fff;
        border-bottom: 1px solid #ccc;
        z-index: 1000;
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
        text-align: center;
    }
    .center ul {
        list-style: none;
        display: inline-flex;
        gap: 2rem;
        margin: 0;
        padding: 0;
    }
    .nav-link {
        text-decoration: none;
        color: #333;
        transition: color 0.2s;
    }
    .nav-link:hover {
        color: #000;
    }
    .right {
        text-align: right;
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
        color: currentColor;
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

    .navbar.dark {
        background: #000;
        border-bottom-color: #000;
    }

    .navbar.dark .left h1,
    .navbar.dark .nav-link,
    .navbar.dark .basket-icon {
        color: #fff;
    }

    .added-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        width: 320px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        z-index: 1100;
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

    .scroll-container {
        margin-top: 80px;
        height: calc(100vh - 80px);
        overflow-y: scroll;
        scroll-snap-type: y mandatory;
        box-sizing: border-box;
    }

    .screen {
        scroll-snap-align: start;
        width: 100%;
        height: calc(100vh - 80px);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        padding: 2rem;
        box-sizing: border-box;
    }

    .artist-info {
        position: relative;
    }
    .artist-info::before {
        content: "";
        position: absolute;
        inset: 0;
        background-color: rgba(255, 255, 255, 0.7);
        z-index: 0;
    }
    .info-container {
        position: relative;
        z-index: 1;
        max-width: 1200px;
        width: 100%;
        display: flex;
        gap: 2rem;
        align-items: center;
        justify-content: space-around;
    }
    .text {
        flex: 1;
    }
    .text h2 {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: #333;
    }
    .text p {
        font-size: 1.25rem;
        line-height: 1.6;
        color: #555;
        margin-bottom: 0.75rem;
    }
    .background {
        color: #777;
    }
    .image {
        flex: 1;
        display: flex;
        justify-content: center;
    }
    .image img {
        max-width: 90%;
        max-height: 80vh;
        border-radius: 8px;
        object-fit: cover;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    }

    .artworks-screen {
        background-size: cover;
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .art-row {
        display: flex;
        justify-content: center;
        gap: 1.5rem;
        width: 100%;
    }
    .artwork-card {
        text-decoration: none;
        overflow: hidden;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        transition:
            transform 0.2s,
            box-shadow 0.2s;
        background: #fff;
        width: 300px;
        height: 400px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .artwork-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    .artwork-card img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .contact-artist {
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        padding: 3rem 1rem;
        position: relative;
        overflow: hidden;
    }

    .contact-artist::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%"><defs><filter id="filter"><feTurbulence type="fractalNoise" baseFrequency="0.01" numOctaves="3" /><feDisplacementMap in="SourceGraphic" scale="180" /></filter></defs><rect width="100%" height="100%" filter="url(%23filter)" opacity="0.3" /></svg>');
        z-index: 0;
        opacity: 0.6;
        pointer-events: none;
    }

    .contact-card-container {
        display: flex;
        justify-content: center;
        width: 100%;
        max-width: 1200px;
        z-index: 1;
    }

    .contact-card {
        width: 100%;
        max-width: 450px;
        padding: 2.5rem;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        transition:
            transform 0.3s,
            box-shadow 0.3s;
    }

    .contact-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
    }

    .contact-card h2 {
        font-size: 2.2rem;
        margin-bottom: 1rem;
        color: #333;
    }

    .contact-card p {
        font-size: 1.1rem;
        color: #555;
        margin-bottom: 2rem;
    }

    .contact-form {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .form-row {
        display: flex;
        gap: 1rem;
    }

    .contact-form input,
    .contact-form textarea {
        width: 100%;
        padding: 1rem;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 1rem;
        box-sizing: border-box;
        transition:
            border-color 0.3s,
            box-shadow 0.3s;
        background-color: rgba(255, 255, 255, 0.8);
    }

    .contact-form input:focus,
    .contact-form textarea:focus {
        outline: none;
        border-color: #ff5e62;
        box-shadow: 0 0 0 2px rgba(255, 94, 98, 0.1);
    }

    .contact-form button {
        background-color: #000;
        color: #fff;
        padding: 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 1.1rem;
        transition: all 0.3s ease;
        align-self: center;
        min-width: 180px;
        letter-spacing: 0.5px;
    }

    .contact-form button:hover {
        background-color: #ff5e62;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(255, 94, 98, 0.3);
    }

    @media (max-width: 768px) {
        .info-container {
            flex-direction: column;
        }
        .art-row {
            flex-direction: column;
            align-items: center;
        }
        .artwork-card {
            width: 90%;
            max-width: 300px;
        }
        .cart-sidebar {
            width: 100%;
        }
        .added-notification {
            width: calc(100% - 40px);
            right: 20px;
            left: 20px;
        }
        .form-row {
            flex-direction: column;
        }

        .contact-container {
            padding: 2rem 1.5rem;
        }
    }

    .logo-link {
        text-decoration: none;
        color: inherit;
    }
</style>
