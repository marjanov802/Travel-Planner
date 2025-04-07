<script>
    import { onMount, tick } from "svelte";

    const artists = [
        {
            name: "Dan Bullock",
            portrait: "/images/danbullock/1.jpg",
            slug: "dan-bullock",
            quote: "Art is the silent language that connects hearts across generations.",
            medium: "Painting",
        },
        {
            name: "Julio Cesart",
            portrait: "/images/juliocesart/1.jpg",
            slug: "julio-cesart",
            quote: "I shape materials to reveal what's already there, waiting to be discovered.",
            medium: "Pencil Drawings",
        },
        {
            name: "Maria Guimaraes",
            portrait: "/images/mariaguimaraes/1.jpg",
            slug: "mariaguimaraes",
            quote: "Between reality and imagination lies the space where my work breathes.",
            medium: "Vibrant oil painting",
        },
    ];

    let cartItems = [];
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;

    function addToCart(artwork) {
        const existingItem = cartItems.find((item) => item.src === artwork);
        if (existingItem) {
            existingItem.quantity += 1;
            cartItems = [...cartItems];
        } else {
            const newItem = {
                id: Date.now(),
                src: artwork,
                quantity: 1,
                price: 299.99,
                artist: getArtistFromSrc(artwork),
                title: "Original artwork piece",
            };

            cartItems = [...cartItems, newItem];

            lastAddedItem = newItem;

            showAddedNotification = true;

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

    function exploreArtist(slug) {
        window.location.href = `/artist/${slug}`;
    }

    let currentSlide = 0;
    let isTransitioning = false;
    const totalSlides = artists.length;

    let previousSlide = -1;

    let direction = 1;

    $: progress = (currentSlide / (totalSlides - 1)) * 100;
    $: formattedCurrentSlide = (currentSlide + 1).toString().padStart(2, "0");
    $: formattedTotalSlides = totalSlides.toString().padStart(2, "0");

    async function changeSlide(newIndex) {
        if (isTransitioning) return;
        isTransitioning = true;

        direction = newIndex > currentSlide ? 1 : -1;

        if (newIndex === 0 && currentSlide === totalSlides - 1) direction = 1;
        if (newIndex === totalSlides - 1 && currentSlide === 0) direction = -1;

        previousSlide = currentSlide;
        currentSlide = newIndex;

        await tick();
        setTimeout(() => {
            isTransitioning = false;
        }, 1000);
    }

    function prevSlide() {
        const newIndex = (currentSlide - 1 + totalSlides) % totalSlides;
        changeSlide(newIndex);
    }

    function nextSlide() {
        const newIndex = (currentSlide + 1) % totalSlides;
        changeSlide(newIndex);
    }

    function goToSlide(index) {
        if (index === currentSlide) return;
        changeSlide(index);
    }

    function handleKeydown(e) {
        if (e.key === "ArrowLeft") {
            prevSlide();
        } else if (e.key === "ArrowRight") {
            nextSlide();
        }
    }

    let touchStartX = 0;
    let touchEndX = 0;

    function handleTouchStart(e) {
        touchStartX = e.touches[0].clientX;
    }

    function handleTouchMove(e) {
        touchEndX = e.touches[0].clientX;
    }

    function handleTouchEnd() {
        const threshold = 75;
        if (touchStartX - touchEndX > threshold) {
            nextSlide();
        } else if (touchEndX - touchStartX > threshold) {
            prevSlide();
        }
    }

    let autoplayInterval;
    let isPaused = false;

    function startAutoplay() {
        stopAutoplay();
        autoplayInterval = setInterval(() => {
            if (!isPaused) nextSlide();
        }, 6000);
    }

    function stopAutoplay() {
        if (autoplayInterval) clearInterval(autoplayInterval);
    }

    function pauseAutoplay() {
        isPaused = true;
    }

    function resumeAutoplay() {
        isPaused = false;
    }

    onMount(() => {
        document
            .querySelector(".artist-slide:first-child")
            .classList.add("force-visible");

        setTimeout(() => {
            startAutoplay();
        }, 1000);

        artists.forEach((artist) => {
            const img = new Image();
            img.src = artist.portrait;
        });

        const savedCart = localStorage.getItem("cartItems");
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
        }

        return () => {
            stopAutoplay();
        };
    });

    $: slideAnnouncement = `Viewing artist ${artists[currentSlide].name}, slide ${currentSlide + 1} of ${totalSlides}`;
</script>

<svelte:window on:keydown={handleKeydown} />

<div aria-live="polite" class="sr-only">{slideAnnouncement}</div>

<nav class="navbar">
    <div class="nav-left">
        <a href="/" class="logo-link">
            <h1>Marjanov</h1>
        </a>
    </div>
    <div class="nav-center">
        <ul>
            <li><a href="/" class="nav-link">Discover</a></li>
            <li><a href="/artist" class="nav-link active">Artists</a></li>
        </ul>
    </div>
    <div class="nav-right">
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
                    <p class="empty-cart-subtitle">
                        Discover our collection and add some art to your cart
                    </p>
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
                            aria-label="Remove item"
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
                <a href="/checkout" class="checkout-btn">Proceed to Checkout</a>
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

<section
    class="artist-showcase"
    on:mouseenter={pauseAutoplay}
    on:mouseleave={resumeAutoplay}
    on:touchstart={handleTouchStart}
    on:touchmove={handleTouchMove}
    on:touchend={handleTouchEnd}
>
    <div
        class="artist-slider"
        aria-roledescription="carousel"
        aria-label="Featured artists"
    >
        {#each artists as artist, i}
            <div
                class="artist-slide"
                class:active={i === currentSlide ||
                    (i === 0 && currentSlide === 0)}
                class:previous={i === previousSlide}
                class:slide-from-right={direction === 1 &&
                    i === currentSlide &&
                    previousSlide !== -1}
                class:slide-from-left={direction === -1 &&
                    i === currentSlide &&
                    previousSlide !== -1}
                class:slide-to-left={direction === 1 && i === previousSlide}
                class:slide-to-right={direction === -1 && i === previousSlide}
                role="group"
                aria-roledescription="slide"
                aria-label={`${i + 1} of ${artists.length}: ${artist.name}`}
                aria-hidden={i !== currentSlide}
            >
                <div
                    class="slide-background"
                    style="background-image: url({artist.portrait});"
                ></div>
                <div class="slide-content">
                    <div class="artist-info">
                        <div class="artist-medium">{artist.medium}</div>
                        <h2 class="artist-name">{artist.name}</h2>
                        <div class="artist-quote">"{artist.quote}"</div>
                        <button
                            class="explore-button"
                            on:click={() => exploreArtist(artist.slug)}
                            aria-label={`Explore ${artist.name}'s work`}
                        >
                            Explore Artist
                            <span class="arrow">→</span>
                        </button>
                    </div>
                </div>
            </div>
        {/each}
    </div>

    <div class="slider-nav">
        <div class="slider-controls">
            <button
                class="nav-btn nav-prev"
                on:click={prevSlide}
                aria-label="Previous artist"
                title="Previous artist"
            >
                <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    aria-hidden="true"
                    ><line x1="19" y1="12" x2="5" y2="12"></line><polyline
                        points="12 19 5 12 12 5"
                    ></polyline></svg
                >
            </button>
            <button
                class="nav-btn nav-next"
                on:click={nextSlide}
                aria-label="Next artist"
                title="Next artist"
            >
                <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    aria-hidden="true"
                    ><line x1="5" y1="12" x2="19" y2="12"></line><polyline
                        points="12 5 19 12 12 19"
                    ></polyline></svg
                >
            </button>
        </div>

        <div class="pagination-dots">
            {#each artists as _, i}
                <button
                    class="pagination-dot"
                    class:active={i === currentSlide}
                    on:click={() => goToSlide(i)}
                    aria-label={`Go to slide ${i + 1}`}
                    aria-current={i === currentSlide ? "true" : "false"}
                ></button>
            {/each}
        </div>

        <div class="slider-pagination">
            <div class="pagination-numbers">
                <span class="pagination-count">{formattedCurrentSlide}</span>
                <span class="pagination-separator">/</span>
                <span class="pagination-total">{formattedTotalSlides}</span>
            </div>
            <div class="progress-bar">
                <div class="progress-bar-fill" style="width: {progress}%"></div>
            </div>
        </div>
    </div>
</section>

<style>
    .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border-width: 0;
    }

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

    .nav-left {
        flex: 1;
    }

    .logo-link {
        text-decoration: none;
    }

    .nav-left h1 {
        margin: 0;
        font-size: 2rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        color: #333;
    }

    .nav-center {
        flex: 1;
        display: flex;
        justify-content: center;
    }

    .nav-center ul {
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

    .nav-link.active {
        color: #000;
        font-weight: bold;
    }

    .nav-right {
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
        font-weight: 600;
        letter-spacing: 1.2px;
        text-transform: uppercase;
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
        color: #555;
        text-align: center;
    }

    .empty-cart-icon {
        margin-bottom: 16px;
        color: #999;
    }

    .empty-cart-subtitle {
        font-size: 13px;
        color: #888;
        margin-top: 8px;
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
        font-size: 14px;
        font-weight: 500;
    }

    .item-artist {
        margin: 0 0 5px;
        font-size: 0.9rem;
        color: #666;
        font-style: italic;
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
        padding: 5px;
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
        color: #333;
        text-transform: uppercase;
        font-size: 14px;
        letter-spacing: 0.5px;
    }

    .checkout-btn {
        display: block;
        background: #333;
        color: white;
        text-align: center;
        padding: 12px;
        border-radius: 4px;
        text-decoration: none;
        font-weight: 600;
        letter-spacing: 1px;
        text-transform: uppercase;
        font-size: 13px;
        transition: all 0.2s;
    }

    .checkout-btn:hover {
        background: #000;
    }

    .continue-shopping-btn {
        display: block;
        width: 100%;
        background: none;
        border: none;
        padding: 12px;
        margin-top: 10px;
        color: #555;
        font-size: 13px;
        cursor: pointer;
        transition: color 0.2s;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .continue-shopping-btn:hover {
        color: #000;
    }

    .artist-showcase {
        position: relative;
        height: calc(100vh - 73px);
        background-color: #000;
        overflow: hidden;
    }

    .artist-showcase:before {
        content: "";
        display: none;
    }

    .artist-slider {
        width: 100%;
        height: 100%;
        position: relative;
    }

    .artist-slide {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        visibility: hidden;
        transition:
            opacity 1s ease,
            visibility 1s ease,
            transform 1s ease;
    }

    .artist-slide.active {
        opacity: 1;
        visibility: visible;
        transform: translateX(0);
        z-index: 2;
    }

    .slide-from-right {
        transform: translateX(50px);
    }

    .slide-from-left {
        transform: translateX(-50px);
    }

    .slide-to-left {
        transform: translateX(-50px);
    }

    .slide-to-right {
        transform: translateX(50px);
    }

    .artist-slide.force-visible {
        opacity: 1 !important;
        visibility: visible !important;
        z-index: 10 !important;
        transform: translateX(0) !important;
    }

    .artist-slide.force-visible .slide-background {
        transform: scale(1) !important;
    }

    .artist-slide.force-visible .artist-info {
        opacity: 1 !important;
        transform: translateY(0) !important;
    }

    .artist-slide.active {
        opacity: 1;
        visibility: visible;
        transform: translateX(0);
        z-index: 2;
    }

    .artist-slide.previous {
        opacity: 0;
        z-index: 1;
    }

    .slide-background {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-size: cover;
        background-position: center;
        filter: brightness(0.6);
        transform: scale(1.1);
        transition:
            transform 8s ease,
            filter 1s ease;
    }

    .artist-slide.active .slide-background {
        transform: scale(1);
    }

    .artist-slide.active .slide-background {
        transform: scale(1);
    }

    .slide-content {
        position: relative;
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        padding: 0 5rem;
        z-index: 2;
    }

    .artist-info {
        max-width: 500px;
        opacity: 0;
        transform: translateY(30px);
        transition:
            opacity 0.8s ease 0.5s,
            transform 0.8s ease 0.5s;
    }

    .artist-slide.active .artist-info {
        opacity: 1;
        transform: translateY(0);
    }

    .artist-slide.active .artist-info {
        opacity: 1;
        transform: translateY(0);
    }

    .artist-medium {
        display: inline-block;
        padding: 0.5rem 1rem;
        background-color: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(10px);
        border-radius: 4px;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 2px;
        margin-bottom: 1.5rem;
        color: #fff;
    }

    .artist-name {
        font-size: 4rem;
        font-weight: 700;
        margin-bottom: 1.5rem;
        line-height: 1.1;
        color: #fff;
        text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
    }

    .artist-quote {
        font-size: 1.2rem;
        font-style: italic;
        margin-bottom: 2.5rem;
        opacity: 0.9;
        max-width: 400px;
        line-height: 1.6;
        color: #fff;
    }

    .explore-button {
        display: inline-flex;
        align-items: center;
        background-color: #fff;
        color: #000;
        padding: 1rem 2rem;
        font-size: 1rem;
        font-weight: 600;
        border-radius: 8px;
        transition:
            transform 0.3s ease,
            background-color 0.3s ease,
            box-shadow 0.3s ease;
        border: none;
        cursor: pointer;
    }

    .explore-button:hover {
        transform: translateY(-3px);
        background-color: #f2f2f2;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
    }

    .explore-button:focus {
        outline: none;
        box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.5);
    }

    .arrow {
        margin-left: 0.8rem;
        transition: transform 0.3s ease;
    }

    .explore-button:hover .arrow {
        transform: translateX(5px);
    }

    .slider-nav {
        position: absolute;
        bottom: 2rem;
        left: 0;
        width: 100%;
        padding: 0 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        z-index: 10;
    }

    .slider-controls {
        display: flex;
        gap: 1rem;
    }

    .nav-btn {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        border: 1px solid rgba(255, 255, 255, 0.3);
        background: rgba(0, 0, 0, 0.2);
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .nav-btn:hover {
        background-color: rgba(255, 255, 255, 0.1);
        transform: translateY(-2px);
    }

    .nav-btn:focus {
        outline: none;
        box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.5);
    }

    .pagination-dots {
        display: flex;
        gap: 0.5rem;
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
    }

    .pagination-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.3);
        border: none;
        transition: all 0.3s ease;
        cursor: pointer;
        padding: 0;
    }

    .pagination-dot:hover {
        background-color: rgba(255, 255, 255, 0.5);
    }

    .pagination-dot.active {
        background-color: #fff;
        transform: scale(1.2);
    }

    .slider-pagination {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        gap: 0.8rem;
    }

    .pagination-numbers {
        font-size: 1rem;
        font-weight: 500;
        color: #fff;
    }

    .progress-bar {
        width: 100px;
        height: 2px;
        background-color: rgba(255, 255, 255, 0.2);
        position: relative;
        overflow: hidden;
        border-radius: 2px;
    }

    .progress-bar-fill {
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        background-color: #fff;
        transition: width 0.5s ease;
    }

    @media (max-width: 992px) {
        .artist-name {
            font-size: 3.5rem;
        }
    }

    @media (max-width: 768px) {
        .navbar {
            padding: 1rem;
        }

        .nav-left h1 {
            font-size: 1.5rem;
        }

        .nav-center ul {
            gap: 1rem;
        }

        .artist-name {
            font-size: 2.5rem;
        }

        .artist-quote {
            font-size: 1rem;
        }

        .slide-content {
            padding: 0 2rem;
            align-items: flex-end;
            padding-bottom: 6rem;
        }

        .slider-nav {
            bottom: 1.5rem;
        }

        .nav-btn {
            width: 40px;
            height: 40px;
        }

        .pagination-dots {
            display: none;
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

    @media (max-width: 480px) {
        .artist-name {
            font-size: 2rem;
        }

        .artist-info {
            max-width: 100%;
        }

        .explore-button {
            padding: 0.8rem 1.5rem;
        }

        .slider-controls {
            gap: 0.5rem;
        }

        .nav-btn {
            width: 36px;
            height: 36px;
        }

        .progress-bar {
            width: 60px;
        }
    }
</style>
