<script>
    import { onMount } from "svelte";

    // Image paths configuration
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

    // Shopping cart functionality
    let cartItems = [];
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;

    function addToCart(artwork) {
        const existingItem = cartItems.find((item) => item.src === artwork);
        if (existingItem) {
            existingItem.quantity += 1;
            cartItems = [...cartItems]; // Trigger reactivity
        } else {
            // Create new item object
            const newItem = {
                id: Date.now(),
                src: artwork,
                quantity: 1,
                price: 299.99,
                artist: getArtistFromSrc(artwork),
                title: "Original artwork piece",
            };

            cartItems = [...cartItems, newItem];

            // Set the last added item for the notification
            lastAddedItem = newItem;

            // Show notification
            showAddedNotification = true;

            // Auto-hide notification after 3 seconds
            setTimeout(() => {
                showAddedNotification = false;
            }, 3000);
        }
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
    }

    function getArtistFromSrc(src) {
        if (src.includes("danbullock")) {
            return "Dan Bullock";
        } else if (src.includes("juliocesart")) {
            return "Julio Cesart";
        } else if (src.includes("mariaguimaraes")) {
            return "Maria Guimaraes";
        }
        return "Unknown Artist";
    }

    function removeFromCart(id) {
        cartItems = cartItems.filter((item) => item.id !== id);
        localStorage.setItem("cartItems", JSON.stringify(cartItems));
    }

    function getCartTotal() {
        return cartItems.reduce(
            (total, item) => total + item.price * item.quantity,
            0,
        );
    }

    function getCartCount() {
        return cartItems.reduce((count, item) => count + item.quantity, 0);
    }

    function toggleCart() {
        isCartOpen = !isCartOpen;
    }

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

        // Load cart from localStorage if it exists
        const savedCart = localStorage.getItem("cartItems");
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
        }
    });
</script>

<!-- Navigation Bar -->
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
            {#if cartItems.length > 0}
                <span class="cart-count">{getCartCount()}</span>
            {/if}
        </div>
    </div>
</nav>

<!-- Added to Cart Notification -->
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
                    £{lastAddedItem.price.toFixed(2)}
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
                View Cart ({getCartCount()})
            </button>
        </div>
    </div>
{/if}

<!-- Cart Sidebar -->
{#if isCartOpen}
    <div class="cart-overlay" on:click={() => (isCartOpen = false)}></div>
    <div class="cart-sidebar">
        <div class="cart-header">
            <h3>Your Cart ({getCartCount()})</h3>
            <button class="close-cart" on:click={() => (isCartOpen = false)}
                >×</button
            >
        </div>

        <div class="cart-items">
            {#if cartItems.length === 0}
                <div class="empty-cart">
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
                            <div class="item-quantity-price">
                                <p class="item-quantity">
                                    Qty: {item.quantity}
                                </p>
                                <p class="item-price">
                                    £{(item.price * item.quantity).toFixed(2)}
                                </p>
                            </div>
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
                    <span>£{getCartTotal().toFixed(2)}</span>
                </div>
                <a href="/checkout" class="checkout-button"
                    >Proceed to Checkout</a
                >
                <button
                    class="continue-shopping-btn"
                    on:click={() => (isCartOpen = false)}
                >
                    Continue Shopping
                </button>
            </div>
        {/if}
    </div>
{/if}

<!-- Grid -->
<div class="masonry">
    {#each shuffledArtworks as artwork}
        <div class="masonry-item">
            <a href={"/artwork?src=" + encodeURIComponent(artwork)}>
                <div class="image-container">
                    <img src={artwork} alt="Artwork" />
                    <div class="overlay">
                        <span class="view-text">View</span>
                        <button
                            class="add-to-cart-btn"
                            on:click|stopPropagation={(e) => {
                                e.preventDefault();
                                addToCart(artwork);
                            }}>Add to Cart</button
                        >
                    </div>
                </div>
            </a>
        </div>
    {/each}
</div>

<style>
    :global(body) {
        margin: 0;
        font-family: Arial, sans-serif;
        overflow-y: auto;
    }

    .navbar {
        display: flex;
        align-items: center;
        padding: 1rem 2rem;
        border-bottom: 1px solid #ccc;
        position: relative;
    }
    .left {
        flex: 1;
    }
    .logo-link {
        text-decoration: none;
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
        position: relative;
        cursor: pointer;
        padding: 6px;
    }
    .basket-icon {
        width: 24px;
        height: 24px;
        color: #333;
        display: block;
    }
    .cart-count {
        position: absolute;
        top: -4px;
        right: -4px;
        background-color: #e53e3e;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 0.5px;
    }

    /* Added to Cart Notification */
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

    /* Cart Sidebar */
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
        justify-content: center;
        align-items: center;
        height: 200px;
        color: #888;
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

    .item-quantity-price {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 5px;
    }

    .item-quantity {
        font-size: 0.8rem;
        color: #888;
        margin: 0;
    }

    .item-price {
        font-weight: bold;
        font-size: 0.9rem;
        margin: 0;
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
        display: block;
        width: 100%;
        padding: 12px;
        background: #000;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.2s;
        text-align: center;
        text-decoration: none;
    }

    .checkout-button:hover {
        background: #333;
    }

    .continue-shopping-btn {
        display: block;
        width: 100%;
        padding: 12px;
        margin-top: 10px;
        background: none;
        border: none;
        color: #666;
        font-size: 0.9rem;
        cursor: pointer;
        text-align: center;
    }

    .continue-shopping-btn:hover {
        text-decoration: underline;
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
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 12px;
        opacity: 0;
        transition: opacity 0.3s ease;
    }
    .image-container:hover .overlay {
        opacity: 1;
    }
    .view-text {
        font-size: 18px;
        font-weight: 500;
    }
    .add-to-cart-btn {
        background: white;
        color: #333;
        border: none;
        padding: 8px 14px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 600;
        transition: all 0.2s;
        font-size: 12px;
        letter-spacing: 0.8px;
        text-transform: uppercase;
    }
    .add-to-cart-btn:hover {
        background: #333;
        color: white;
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
        .cart-sidebar {
            width: 100%;
        }
        .added-notification {
            width: calc(100% - 40px);
            right: 20px;
            left: 20px;
        }
    }
    @media (max-width: 400px) {
        .masonry {
            column-count: 1;
        }
    }
</style>
