<script>
    import { onMount } from "svelte";

    let currentSection = 0;
    let scrolling = false;
    let touchStartY = 0;
    let sections;
    let artworkLayers = [];
    let imageLoaded = Array(8).fill(false);
    let progress = 0;
    let isLoading = true;
    let wheelDebounceTimer;
    let isAnimating = false;
    let preloadedImages = 0;
    let overlayOpacity = 0;
    let mousePosition = { x: 0, y: 0 };
    let artworkDetails = false;
    let selectedArtwork = null;
    let contentWrapper;
    let initialLoadDone = false;
    let showArtistBio = false;

    let cartItems = [];
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;
    let cartCount = 0;

    const artist = {
        name: "Julio Cesar T",
        bio: "Contemporary artist exploring the threshold between presence and absence through ethereal, monochromatic compositions. Based in Madrid, Spain, Julio's work has been exhibited in prestigious galleries across Europe and North America, including MoMA PS1 in New York and the Whitechapel Gallery in London.",
        statement:
            "My work examines the fragile boundary between presence and absence. Through layered transparency and selective focus, I create images that exist in a liminal space between materiality and spirituality. Each piece serves as an exploration of that which exists between states—the ethereal made tangible, the spiritual given form, the unseen rendered visible.",
        approach:
            "I work primarily with digital techniques and traditional media to create layered, translucent compositions. My process involves building up multiple transparent elements that allow light and form to interact in ways that suggest both materiality and transcendence. Color plays a crucial role in my work, with each monochromatic palette chosen to evoke specific emotional and spiritual resonances.",
        background:
            "After studying fine arts at the Royal Academy in Madrid, I developed a unique approach that combines digital manipulation with traditional drawing techniques. My early works focused on figurative subjects rendered in grayscale, but my recent explorations have expanded to include vibrant monochromatic color fields that emphasize the ethereal quality of the forms.",
        exhibitions: [
            "Galerie Moderne, Paris (2023)",
            "MoMA PS1, New York (2022)",
            "Whitechapel Gallery, London (2021)",
            "Prado Annex, Madrid (2020)",
            "Venice Biennale, Emerging Artists Pavilion (2019)",
        ],
        portraitUrl: "/images/juliocesart/1.jpg",
        color: "#161938",
        textColor: "#ffffff",
        accentColor: "#b3c6ff",
    };

    const artworks = [
        {
            id: 1,
            title: "Fallen Angel",
            year: "2022",
            medium: "Graphite on paper",
            size: "120 × 90 cm",
            description:
                "An exploration of descent and ethereality, where the subject appears suspended between realms.",
            imageUrl: "/images/juliocesart/1.jpg",
            color: "#1a1a1a",
            textColor: "#ffffff",
            accentColor: "#c0c0c0",
        },
        {
            id: 2,
            title: "Magenta Empress",
            year: "2021",
            medium: "Digital print",
            size: "100 × 140 cm",
            description:
                "Translucent layers of magenta form a haunting royal presence that emerges from and dissolves into its surroundings.",
            imageUrl: "/images/juliocesart/2.jpg",
            color: "#a01573",
            textColor: "#ffffff",
            accentColor: "#ffa0e0",
        },
        {
            id: 3,
            title: "Verdant Crown",
            year: "2023",
            medium: "Mixed media",
            size: "120 × 180 cm",
            description:
                "Nature and regality converge in this piece where organic forms create a crown-like apparition.",
            imageUrl: "/images/juliocesart/3.jpg",
            color: "#0d1f12",
            textColor: "#ffffff",
            accentColor: "#7fff7f",
        },
        {
            id: 4,
            title: "Cardinal Thread",
            year: "2020",
            medium: "Digital print on silk",
            size: "150 × 90 cm",
            description:
                "A delicate red line weaves through translucent layers, connecting visible and invisible realms.",
            imageUrl: "/images/juliocesart/4.jpg",
            color: "#8c0000",
            textColor: "#ffffff",
            accentColor: "#ff9999",
        },
        {
            id: 5,
            title: "Weightless Form",
            year: "2022",
            medium: "Charcoal on paper",
            size: "100 × 80 cm",
            description:
                "The human figure liberated from gravity, existing in a state between materiality and spirit.",
            imageUrl: "/images/juliocesart/5.jpg",
            color: "#000033",
            textColor: "#ffffff",
            accentColor: "#d6e6ff",
        },
        {
            id: 6,
            title: "Ember Child",
            year: "2023",
            medium: "Oil on canvas",
            size: "90 × 90 cm",
            description:
                "Youth preserved in warm luminescence, a meditation on memory and innocence.",
            imageUrl: "/images/juliocesart/6.jpg",
            color: "#661400",
            textColor: "#ffffff",
            accentColor: "#ffbd99",
        },
        {
            id: 7,
            title: "Phosphorescent Oracle",
            year: "2021",
            medium: "Digital print",
            size: "150 × 200 cm",
            description:
                "A prophetic figure rendered in ethereal green tones, emerging from otherworldly dimensions.",
            imageUrl: "/images/juliocesart/7.jpg",
            color: "#0d1f12",
            textColor: "#ffffff",
            accentColor: "#a5ffa5",
        },
    ];

    function preloadImages() {
        const portraitImg = new Image();
        portraitImg.src = artist.portraitUrl;
        portraitImg.onload = () => {
            imageLoaded[0] = true;
            preloadedImages++;
            updateProgress();
        };

        artworks.forEach((artwork, index) => {
            const img = new Image();
            img.src = artwork.imageUrl;
            img.onload = () => {
                imageLoaded[index + 1] = true;
                preloadedImages++;
                updateProgress();
            };
        });
    }

    function updateProgress() {
        progress = (preloadedImages / (artworks.length + 1)) * 100;

        if (preloadedImages === artworks.length + 1) {
            setTimeout(() => {
                isLoading = false;
                setTimeout(() => {
                    initialLoadDone = true;
                }, 1500);
            }, 1000);
        }
    }

    function handleWheel(event) {
        if (isAnimating || artworkDetails || showArtistBio || isCartOpen)
            return;

        clearTimeout(wheelDebounceTimer);
        wheelDebounceTimer = setTimeout(() => {
            const direction = event.deltaY > 0 ? 1 : -1;
            scrollToSection(currentSection + direction);
        }, 50);
    }

    function handleKeydown(event) {
        if (isAnimating || artworkDetails || showArtistBio || isCartOpen)
            return;

        if (event.key === "ArrowDown" || event.key === "PageDown") {
            scrollToSection(currentSection + 1);
        } else if (event.key === "ArrowUp" || event.key === "PageUp") {
            scrollToSection(currentSection - 1);
        } else if (event.key === "Escape") {
            if (artworkDetails) {
                closeArtworkDetails();
            } else if (showArtistBio) {
                closeArtistBio();
            } else if (isCartOpen) {
                toggleCart();
            }
        }
    }

    function handleTouchStart(event) {
        touchStartY = event.touches[0].clientY;
    }

    function handleTouchMove(event) {
        if (isAnimating || artworkDetails || showArtistBio || isCartOpen)
            return;

        const touchY = event.touches[0].clientY;
        const diff = touchStartY - touchY;

        if (Math.abs(diff) > 50) {
            const direction = diff > 0 ? 1 : -1;
            scrollToSection(currentSection + direction);
            touchStartY = touchY;
        }
    }

    function scrollToSection(index) {
        if (index < 0 || index > artworks.length || isAnimating) return;

        isAnimating = true;
        currentSection = index;

        setTimeout(() => {
            isAnimating = false;
        }, 1000);
    }

    function handleMouseMove(event) {
        if (artworkDetails || showArtistBio || isCartOpen) return;

        const { clientX, clientY } = event;
        mousePosition = {
            x: clientX / window.innerWidth,
            y: clientY / window.innerHeight,
        };
    }

    function openArtworkDetails(artwork) {
        selectedArtwork = artwork;
        artworkDetails = true;
        document.body.style.overflow = "hidden";
    }

    function closeArtworkDetails() {
        artworkDetails = false;
        document.body.style.overflow = "auto";
    }

    function openArtistBio() {
        showArtistBio = true;
        document.body.style.overflow = "hidden";
    }

    function closeArtistBio() {
        showArtistBio = false;
        document.body.style.overflow = "auto";
    }

    function toggleCart() {
        isCartOpen = !isCartOpen;
        if (isCartOpen) {
            document.body.style.overflow = "hidden";
        } else {
            document.body.style.overflow = "auto";
        }
    }

    function addToCart(artwork, editionType = "Limited Edition Print") {
        const price = getArtworkPrice(artwork, editionType);
        const newItem = {
            id: Date.now(),
            title: artwork.title,
            artist: artist.name,
            year: artwork.year,
            imageUrl: artwork.imageUrl,
            editionType: editionType,
            price: price,
            quantity: 1,
            src: artwork.imageUrl,
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
        return cartItems.reduce((total, item) => {
            return total + item.price * item.quantity;
        }, 0);
    }

    function getArtworkPrice(artwork, editionType) {
        const basePrices = {
            Original: { min: 5000, max: 15000 },
            "Limited Edition Print": { min: 800, max: 2500 },
            "Open Edition Print": { min: 250, max: 600 },
        };

        const priceRange = basePrices[editionType];
        const priceSpread = priceRange.max - priceRange.min;
        const uniqueFactor = ((artwork.id * 17) % 100) / 100;

        return (
            Math.round((priceRange.min + priceSpread * uniqueFactor) / 10) * 10
        );
    }

    function getParallaxStyle(index) {
        if (!artworkLayers[index]) return "";

        const offsetX = (mousePosition.x - 0.5) * 50;
        const offsetY = (mousePosition.y - 0.5) * 50;

        return `transform: translate(${offsetX * ((index % 3) + 1) * 0.2}px, ${offsetY * ((index % 2) + 1) * 0.2}px)`;
    }

    onMount(() => {
        preloadImages();

        sections = document.querySelectorAll(".section");
        artworkLayers = document.querySelectorAll(".artwork-layer");

        window.addEventListener("keydown", handleKeydown);
        window.addEventListener("mousemove", handleMouseMove);

        const savedCart = localStorage.getItem("artworkCart");
        if (savedCart) {
            cartItems = JSON.parse(savedCart);
            cartCount = cartItems.length;
        }

        return () => {
            window.removeEventListener("keydown", handleKeydown);
            window.removeEventListener("mousemove", handleMouseMove);
        };
    });
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
            <li><a href="/artist" class="nav-link active">Artists</a></li>
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
                <span class="cart-count">{cartCount}</span>
            {/if}
        </div>
    </div>
</nav>

{#if showAddedNotification && lastAddedItem}
    <div class="added-notification">
        <div class="notification-content">
            <div class="notification-image">
                <img src={lastAddedItem.imageUrl} alt="Added artwork" />
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
                            <img src={item.imageUrl} alt="Cart item" />
                        </div>
                        <div class="cart-item-details">
                            <h4>{item.title}</h4>
                            <p class="item-artist">by {item.artist}</p>
                            <p class="item-edition">{item.editionType}</p>
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
                <a
                    href="mailto:info@marjanov.com?subject=Cart Inquiry&body=I'm interested in purchasing the following items from my cart: {cartItems
                        .map(
                            (item) =>
                                `${item.quantity}x ${item.title} (${item.editionType})`,
                        )
                        .join(', ')}"
                    class="checkout-button"
                >
                    Contact Gallery to Purchase
                </a>
            </div>
        {/if}
    </div>
{/if}

{#if isLoading}
    <div class="loading-screen" style="background-color: {artist.color};">
        <div class="loading-content">
            <h1 class="artist-name">{artist.name}</h1>
            <div class="loading-bar-container">
                <div class="loading-bar" style="width: {progress}%"></div>
            </div>
            <div class="loading-text">
                Materializing {Math.floor(progress)}%
            </div>
        </div>
    </div>
{/if}

<div
    class="scroll-indicator"
    class:visible={initialLoadDone &&
        !artworkDetails &&
        !showArtistBio &&
        !isCartOpen}
>
    <div class="indicator-dot" class:active={currentSection === 0}></div>
    <div class="indicator-dot" class:active={currentSection === 1}></div>
    <div class="indicator-dot" class:active={currentSection === 2}></div>
    <div class="indicator-dot" class:active={currentSection === 3}></div>
    <div class="indicator-dot" class:active={currentSection === 4}></div>
    <div class="indicator-dot" class:active={currentSection === 5}></div>
    <div class="indicator-dot" class:active={currentSection === 6}></div>
    <div class="indicator-dot" class:active={currentSection === 7}></div>
</div>

<main
    class="content-wrapper"
    bind:this={contentWrapper}
    on:wheel={handleWheel}
    on:touchstart={handleTouchStart}
    on:touchmove={handleTouchMove}
    class:no-scroll={isAnimating ||
        artworkDetails ||
        showArtistBio ||
        isCartOpen}
>
    <div
        class="sections-container"
        style="transform: translateY(-{currentSection * 100}vh)"
    >
        <section
            class="section artist-intro-section"
            style="background-color: {artist.color}; color: {artist.textColor};"
        >
            <div class="artist-intro-content">
                <div class="artist-intro-left">
                    <div class="artist-portrait-container">
                        <img
                            src={artist.portraitUrl}
                            alt={artist.name}
                            class="artist-portrait"
                        />
                        <div
                            class="portrait-overlay"
                            style="background: radial-gradient(circle, transparent 30%, {artist.color} 100%)"
                        ></div>
                    </div>
                </div>

                <div class="artist-intro-right">
                    <h1 class="artist-name-large">{artist.name}</h1>
                    <div class="artist-tagline">
                        <span style="color: {artist.accentColor}"
                            >Exploring the threshold</span
                        > between presence and absence
                    </div>

                    <div class="artist-bio-content">
                        <p>
                            Madrid-based contemporary artist whose ethereal,
                            monochromatic compositions examine the fragile
                            boundary between materiality and spirituality.
                        </p>

                        <p>
                            After studying at the Royal Academy in Madrid, Julio
                            developed his signature style combining digital
                            manipulation with traditional drawing techniques.
                            His work has been featured in prestigious galleries
                            across Europe and North America.
                        </p>
                    </div>

                    <div class="artist-exhibition-highlight">
                        <span class="exhibition-label">Latest Exhibition:</span>
                        <span class="exhibition-value"
                            >Galerie Moderne, Paris (2023)</span
                        >
                    </div>

                    <button
                        class="artist-bio-button"
                        style="border-color: {artist.accentColor}; color: {artist.accentColor}; background-color: rgba(0,0,0,0.3);"
                        on:click={openArtistBio}
                    >
                        Full Artist Biography
                    </button>
                </div>
            </div>

            <div
                class="nav-cue next-artwork"
                style="color: {artist.accentColor};"
                on:click={() => scrollToSection(1)}
            >
                <span class="nav-text">View Artworks</span>
                <span class="nav-arrow">↓</span>
            </div>

            <div class="section-counter" style="color: {artist.accentColor};">
                Intro / {artworks.length + 1}
            </div>
        </section>

        {#each artworks as artwork, index}
            <section
                class="section artwork-section"
                style="background-color: {artwork.color}; color: {artwork.textColor};"
            >
                <div
                    class="artwork-layer background-layer"
                    style={getParallaxStyle(index * 3)}
                ></div>

                <div
                    class="artwork-layer image-layer"
                    style={getParallaxStyle(index * 3 + 1)}
                >
                    <div class="artwork-image-container">
                        <img
                            src={artwork.imageUrl}
                            alt={artwork.title}
                            class="artwork-image"
                            on:click={() => openArtworkDetails(artwork)}
                        />
                    </div>
                </div>

                <div
                    class="artwork-layer text-layer"
                    style={getParallaxStyle(index * 3 + 2)}
                >
                    <div class="artwork-info">
                        <h2 class="artwork-title">{artwork.title}</h2>
                        <p class="artwork-year">{artwork.year}</p>
                        <div class="info-divider"></div>
                        <p class="artwork-medium">{artwork.medium}</p>
                        <div class="artwork-action-buttons">
                            <button
                                class="view-details-btn"
                                style="border-color: {artwork.accentColor}; color: {artwork.accentColor}; background-color: rgba(0,0,0,0.3);"
                                on:click={() => openArtworkDetails(artwork)}
                            >
                                View Details
                            </button>
                            <button
                                class="add-to-cart-btn"
                                style="background-color: {artwork.accentColor}; color: {artwork.color};"
                                on:click={() =>
                                    addToCart(artwork, "Limited Edition Print")}
                            >
                                Add to Cart
                            </button>
                        </div>
                    </div>
                </div>

                <div
                    class="section-counter"
                    style="color: {artwork.accentColor};"
                >
                    {index + 2}/{artworks.length + 1}
                </div>

                {#if index === 0}
                    <div
                        class="nav-cue prev-artist"
                        style="color: {artwork.accentColor};"
                        on:click={() => scrollToSection(0)}
                    >
                        <span class="nav-arrow">↑</span>
                        <span class="nav-text">Artist</span>
                    </div>
                {:else}
                    <div
                        class="nav-cue prev"
                        style="color: {artwork.accentColor};"
                        on:click={() => scrollToSection(index)}
                    >
                        <span class="nav-arrow">↑</span>
                        <span class="nav-text">{artworks[index - 1].title}</span
                        >
                    </div>
                {/if}

                {#if index < artworks.length - 1}
                    <div
                        class="nav-cue next"
                        style="color: {artwork.accentColor};"
                        on:click={() => scrollToSection(index + 2)}
                    >
                        <span class="nav-text">{artworks[index + 1].title}</span
                        >
                        <span class="nav-arrow">↓</span>
                    </div>
                {/if}
            </section>
        {/each}
    </div>

    {#if !isLoading && !initialLoadDone}
        <div
            class="entry-overlay"
            style="background-color: {artist.color}; opacity: {overlayOpacity}"
        ></div>
    {/if}

    {#if artworkDetails && selectedArtwork}
        <div
            class="artwork-details-modal"
            style="background-color: {selectedArtwork.color}99;"
        >
            <div
                class="modal-content"
                style="border-color: {selectedArtwork.accentColor}"
            >
                <button class="close-modal-btn" on:click={closeArtworkDetails}
                    >×</button
                >

                <div class="modal-left">
                    <img
                        src={selectedArtwork.imageUrl}
                        alt={selectedArtwork.title}
                        class="modal-image"
                    />
                </div>

                <div class="modal-right">
                    <h2
                        class="modal-title"
                        style="color: {selectedArtwork.accentColor}"
                    >
                        {selectedArtwork.title}
                    </h2>
                    <p class="modal-year">{selectedArtwork.year}</p>
                    <div
                        class="modal-divider"
                        style="background-color: {selectedArtwork.accentColor}"
                    ></div>

                    <div class="artwork-metadata">
                        <div class="metadata-item">
                            <span class="metadata-label">Artist</span>
                            <span class="metadata-value">{artist.name}</span>
                        </div>
                        <div class="metadata-item">
                            <span class="metadata-label">Medium</span>
                            <span class="metadata-value"
                                >{selectedArtwork.medium}</span
                            >
                        </div>
                        <div class="metadata-item">
                            <span class="metadata-label">Dimensions</span>
                            <span class="metadata-value"
                                >{selectedArtwork.size}</span
                            >
                        </div>
                    </div>

                    <p class="artwork-description">
                        {selectedArtwork.description}
                    </p>

                    <div class="artwork-context">
                        <h3>Artist Context</h3>
                        <p>
                            This work exemplifies {artist.name}'s exploration of
                            the boundary between presence and absence, utilizing {selectedArtwork.medium.toLowerCase()}
                            to create translucent layers that suggest both materiality
                            and transcendence.
                        </p>
                    </div>

                    <div class="artwork-acquisition">
                        <h3>Acquisition Options</h3>
                        <div class="price-display">
                            Limited Edition Print: <span class="price-value"
                                >£{getArtworkPrice(
                                    selectedArtwork,
                                    "Limited Edition Print",
                                ).toLocaleString()}</span
                            >
                        </div>

                        <button
                            class="add-to-cart-btn-large"
                            style="background-color: {selectedArtwork.accentColor}; color: {selectedArtwork.color};"
                            on:click={() => {
                                addToCart(
                                    selectedArtwork,
                                    "Limited Edition Print",
                                );
                                closeArtworkDetails();
                            }}
                        >
                            Add to Cart
                        </button>

                        <div class="acquisition-contact">
                            <p>
                                For custom framing, original artwork or special
                                requests:
                            </p>
                            <a
                                href="mailto:info@marjanov.com?subject=Inquiry about {selectedArtwork.title}"
                                class="inquiry-button"
                                style="border-color: {selectedArtwork.accentColor}; color: {selectedArtwork.accentColor}; background-color: rgba(0,0,0,0.3);"
                            >
                                Contact Gallery
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}

    {#if showArtistBio}
        <div
            class="artist-bio-modal"
            style="background-color: {artist.color}99;"
        >
            <div
                class="modal-content"
                style="border-color: {artist.accentColor}"
            >
                <button class="close-modal-btn" on:click={closeArtistBio}
                    >×</button
                >

                <div class="bio-left">
                    <img
                        src={artist.portraitUrl}
                        alt={artist.name}
                        class="bio-portrait"
                    />
                    <div class="artist-exhibitions">
                        <h3>Selected Exhibitions</h3>
                        <ul class="exhibitions-list">
                            {#each artist.exhibitions as exhibition}
                                <li>{exhibition}</li>
                            {/each}
                        </ul>
                    </div>
                </div>

                <div class="bio-right">
                    <h2 class="bio-title" style="color: {artist.accentColor}">
                        {artist.name}
                    </h2>
                    <p class="bio-location">Madrid, Spain</p>
                    <div
                        class="bio-divider"
                        style="background-color: {artist.accentColor}"
                    ></div>

                    <div class="bio-section">
                        <h3>Artist Statement</h3>
                        <p>{artist.statement}</p>
                    </div>

                    <div class="bio-section">
                        <h3>Artistic Approach</h3>
                        <p>{artist.approach}</p>
                    </div>

                    <div class="bio-section">
                        <h3>Background</h3>
                        <p>{artist.background}</p>
                    </div>

                    <div class="bio-actions">
                        <button
                            class="bio-action-btn"
                            style="background-color: {artist.accentColor}; color: {artist.color};"
                            on:click={closeArtistBio}
                        >
                            View Artworks
                        </button>
                        <a
                            href="mailto:info@marjanov.com?subject=Inquiry about {artist.name}"
                            class="bio-action-btn outlined"
                            style="border-color: {artist.accentColor}; color: {artist.accentColor}; background-color: rgba(0,0,0,0.3);"
                        >
                            Contact Gallery
                        </a>
                    </div>
                </div>
            </div>
        </div>
    {/if}

    <div
        class="scroll-instructions"
        class:visible={initialLoadDone &&
            !artworkDetails &&
            !showArtistBio &&
            !isCartOpen}
    >
        <div class="instruction-icon">
            <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    d="M12 5V19M12 19L6 13M12 19L18 13"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
            </svg>
        </div>
        <div class="instruction-text">Scroll to explore</div>
    </div>
</main>

<style>
    :global(body) {
        margin: 0;
        padding: 0;
        font-family: "Neue Haas Grotesk", "Helvetica Neue", sans-serif;
        background-color: #000000;
        color: #ffffff;
        overflow-x: hidden;
        overflow-y: auto;
    }

    * {
        box-sizing: border-box;
    }

    .navbar {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        height: 60px;
        display: flex;
        align-items: center;
        padding: 0 2rem;
        background: rgba(0, 0, 0, 0.7);
        backdrop-filter: blur(10px);
        z-index: 100;
    }

    .left h1 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: 500;
        letter-spacing: 0.05em;
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
        color: #fff;
        font-weight: 400;
        font-size: 0.95rem;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        position: relative;
    }

    .nav-link::after {
        content: "";
        position: absolute;
        bottom: -4px;
        left: 0;
        width: 0;
        height: 1px;
        background: #fff;
        transition: width 0.3s;
    }

    .nav-link:hover::after,
    .nav-link.active::after {
        width: 100%;
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
        color: #fff;
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
        background: #111111;
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
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .cart-header h3 {
        margin: 0;
        font-size: 1.2rem;
        font-weight: 400;
    }

    .close-cart {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: white;
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
        color: rgba(255, 255, 255, 0.7);
        text-align: center;
    }

    .empty-cart-icon {
        margin-bottom: 16px;
        color: rgba(255, 255, 255, 0.5);
    }

    .cart-item {
        display: flex;
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
        font-weight: 400;
    }

    .item-artist {
        margin: 0 0 5px;
        font-size: 0.9rem;
        color: rgba(255, 255, 255, 0.7);
    }

    .item-edition {
        font-style: italic;
        margin: 0 0 5px;
        font-size: 0.8rem;
        color: rgba(255, 255, 255, 0.5);
    }

    .item-price {
        font-weight: 500;
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
        color: rgba(255, 255, 255, 0.5);
        cursor: pointer;
    }

    .remove-item:hover {
        color: #e53e3e;
    }

    .cart-footer {
        padding: 20px;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        background: rgba(0, 0, 0, 0.3);
    }

    .cart-total {
        display: flex;
        justify-content: space-between;
        font-weight: 500;
        margin-bottom: 15px;
        font-size: 1.1rem;
    }

    .checkout-button {
        display: block;
        width: 100%;
        padding: 12px;
        background: #3a86ff;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.2s;
        text-align: center;
        text-decoration: none;
        font-weight: 500;
    }

    .checkout-button:hover {
        background: #2a76ef;
    }

    .loading-screen {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
        transition: opacity 0.8s ease-out;
    }

    .loading-content {
        text-align: center;
    }

    .artist-name {
        font-size: 3rem;
        font-weight: 300;
        margin-bottom: 2rem;
        letter-spacing: -0.02em;
        opacity: 0.9;
    }

    .loading-bar-container {
        width: 300px;
        height: 2px;
        background-color: rgba(255, 255, 255, 0.2);
        margin-bottom: 1rem;
    }

    .loading-bar {
        height: 100%;
        background-color: #ffffff;
        transition: width 0.3s ease-out;
    }

    .loading-text {
        font-size: 0.9rem;
        letter-spacing: 0.1em;
        opacity: 0.7;
    }

    .content-wrapper {
        width: 100%;
        height: 100vh;
        overflow: hidden;
        position: relative;
    }

    .no-scroll {
        overflow: hidden;
    }

    .sections-container {
        width: 100%;
        transition: transform 1s cubic-bezier(0.76, 0, 0.24, 1);
    }

    .section {
        width: 100%;
        height: 100vh;
        position: relative;
        overflow: hidden;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .artist-intro-section {
        overflow: hidden;
    }

    .artist-intro-content {
        display: grid;
        grid-template-columns: 1fr 1fr;
        width: 100%;
        max-width: 1400px;
        gap: 4rem;
        padding: 0 2rem;
    }

    .artist-intro-left {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .artist-portrait-container {
        width: 100%;
        max-width: 500px;
        aspect-ratio: 1/1;
        position: relative;
        overflow: hidden;
        border-radius: 4px;
    }

    .artist-portrait {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .portrait-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        pointer-events: none;
    }

    .artist-intro-right {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .artist-name-large {
        font-size: 4rem;
        font-weight: 300;
        margin: 0 0 1rem;
        letter-spacing: -0.03em;
    }

    .artist-tagline {
        font-size: 1.5rem;
        margin-bottom: 2rem;
        font-weight: 300;
        line-height: 1.4;
    }

    .artist-bio-content {
        font-size: 1.1rem;
        line-height: 1.6;
        margin-bottom: 2rem;
        opacity: 0.9;
    }

    .artist-bio-content p {
        margin-bottom: 1rem;
    }

    .artist-exhibition-highlight {
        display: inline-block;
        padding: 0.6rem 1rem;
        background: rgba(255, 255, 255, 0.2);
        border-radius: 4px;
        margin-bottom: 2rem;
    }

    .exhibition-label {
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        opacity: 0.7;
        margin-right: 0.5rem;
    }

    .artist-bio-button {
        align-self: flex-start;
        background: none;
        border: 2px solid;
        padding: 0.8rem 1.5rem;
        font-size: 1rem;
        font-family: inherit;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: 500;
    }

    .artist-bio-button:hover {
        background-color: currentColor;
        color: #000 !important;
    }

    .artwork-layer {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        transition: transform 0.5s ease-out;
    }

    .background-layer {
        z-index: 1;
    }

    .image-layer {
        z-index: 2;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .text-layer {
        z-index: 3;
        display: flex;
        justify-content: flex-end;
        align-items: center;
    }

    .artwork-image-container {
        width: 85vh;
        height: 85vh;
        display: flex;
        justify-content: center;
        align-items: center;
        position: relative;
    }

    .artwork-image {
        max-width: 100%;
        max-height: 100%;
        object-fit: contain;
        cursor: pointer;
        transition: transform 0.5s ease;
        transform-origin: center;
    }

    .artwork-image:hover {
        transform: scale(1.02);
    }

    .artwork-info {
        padding: 2rem;
        max-width: 350px;
        margin-right: 5vw;
        background-color: rgba(0, 0, 0, 0.4);
        backdrop-filter: blur(10px);
        border-radius: 8px;
    }

    .artwork-title {
        font-size: 2.5rem;
        font-weight: 300;
        margin: 0 0 0.5rem;
        letter-spacing: -0.02em;
    }

    .artwork-year {
        font-size: 1.2rem;
        margin: 0 0 1rem;
        opacity: 0.8;
    }

    .info-divider {
        width: 40px;
        height: 2px;
        background-color: currentColor;
        opacity: 0.3;
        margin: 1rem 0;
    }

    .artwork-medium {
        font-size: 1rem;
        margin: 0 0 2rem;
        opacity: 0.7;
    }

    .artwork-action-buttons {
        display: flex;
        gap: 1rem;
        flex-wrap: wrap;
    }

    .view-details-btn {
        background: none;
        border: 2px solid;
        padding: 0.8rem 1.5rem;
        font-size: 0.9rem;
        font-family: inherit;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: 500;
    }

    .view-details-btn:hover {
        background-color: currentColor;
        color: #000 !important;
    }

    .add-to-cart-btn {
        background-color: currentColor;
        border: none;
        padding: 0.8rem 1.5rem;
        font-size: 0.9rem;
        font-family: inherit;
        cursor: pointer;
        transition: opacity 0.3s;
        font-weight: 500;
    }

    .add-to-cart-btn:hover {
        opacity: 0.9;
    }

    .add-to-cart-btn-large {
        width: 100%;
        background-color: currentColor;
        border: none;
        padding: 1rem 1.5rem;
        font-size: 1rem;
        font-family: inherit;
        cursor: pointer;
        transition: opacity 0.3s;
        font-weight: 500;
        margin-bottom: 1.5rem;
    }

    .add-to-cart-btn-large:hover {
        opacity: 0.9;
    }

    .section-counter {
        position: absolute;
        bottom: 2rem;
        left: 2rem;
        font-size: 1rem;
        opacity: 0.7;
        z-index: 4;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
    }

    .nav-cue {
        position: absolute;
        display: flex;
        align-items: center;
        font-size: 0.9rem;
        cursor: pointer;
        opacity: 0.7;
        transition: opacity 0.3s;
        z-index: 4;
        text-shadow: 0 1px 3px rgba(0, 0, 0, 0.5);
    }

    .nav-cue:hover {
        opacity: 1;
    }

    .nav-cue.prev,
    .nav-cue.prev-artist {
        top: 2rem;
        right: 2rem;
    }

    .nav-cue.next,
    .nav-cue.next-artwork {
        bottom: 2rem;
        right: 2rem;
    }

    .nav-arrow {
        margin: 0 0.5rem;
        font-size: 1.2rem;
    }

    .nav-text {
        font-size: 0.9rem;
        letter-spacing: 0.05em;
    }

    .entry-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 50;
        transition: opacity 1.5s ease-out;
    }

    .scroll-indicator {
        position: fixed;
        top: 50%;
        right: 2rem;
        transform: translateY(-50%);
        display: flex;
        flex-direction: column;
        gap: 1rem;
        z-index: 10;
        opacity: 0;
        transition: opacity 0.5s;
    }

    .scroll-indicator.visible {
        opacity: 0.7;
    }

    .indicator-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.3);
        transition:
            transform 0.3s,
            background-color 0.3s;
    }

    .indicator-dot.active {
        background-color: #ffffff;
        transform: scale(1.3);
    }

    .scroll-instructions {
        position: fixed;
        bottom: 2rem;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
        color: #ffffff;
        z-index: 10;
        opacity: 0;
        transition: opacity 0.5s;
    }

    .scroll-instructions.visible {
        opacity: 0.7;
        animation: bounce 2s infinite;
    }

    @keyframes bounce {
        0%,
        20%,
        50%,
        80%,
        100% {
            transform: translateX(-50%) translateY(0);
        }
        40% {
            transform: translateX(-50%) translateY(-10px);
        }
        60% {
            transform: translateX(-50%) translateY(-5px);
        }
    }

    .instruction-text {
        font-size: 0.9rem;
        letter-spacing: 0.1em;
    }

    .artwork-details-modal,
    .artist-bio-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 100;
        backdrop-filter: blur(15px);
        animation: modalFadeIn 0.5s forwards;
    }

    @keyframes modalFadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    .modal-content {
        display: grid;
        grid-template-columns: 1fr 500px;
        max-width: 90vw;
        max-height: 90vh;
        border: 1px solid;
        border-radius: 4px;
        background-color: rgba(0, 0, 0, 0.7);
        position: relative;
        overflow: hidden;
    }

    .close-modal-btn {
        position: absolute;
        top: 1rem;
        right: 1rem;
        width: 40px;
        height: 40px;
        background: none;
        border: none;
        color: white;
        font-size: 2rem;
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        z-index: 5;
        opacity: 0.7;
        transition: opacity 0.3s;
    }

    .close-modal-btn:hover {
        opacity: 1;
    }

    .modal-left,
    .bio-left {
        height: 90vh;
        display: flex;
        flex-direction: column;
        padding: 2rem;
    }

    .modal-image,
    .bio-portrait {
        max-width: 100%;
        max-height: 70%;
        object-fit: contain;
        border-radius: 4px;
    }

    .bio-portrait {
        margin-bottom: 2rem;
    }

    .artist-exhibitions {
        margin-top: auto;
    }

    .artist-exhibitions h3 {
        font-size: 1.3rem;
        font-weight: 400;
        margin: 0 0 1rem;
    }

    .exhibitions-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .exhibitions-list li {
        margin-bottom: 0.8rem;
        padding-left: 1rem;
        position: relative;
    }

    .exhibitions-list li::before {
        content: "•";
        position: absolute;
        left: 0;
        color: rgba(255, 255, 255, 0.5);
    }

    .modal-right,
    .bio-right {
        padding: 2rem;
        overflow-y: auto;
        max-height: 90vh;
    }

    .modal-title,
    .bio-title {
        font-size: 2.5rem;
        font-weight: 300;
        margin: 0 0 0.5rem;
        letter-spacing: -0.02em;
    }

    .modal-year,
    .bio-location {
        font-size: 1.2rem;
        margin: 0 0 1rem;
        opacity: 0.8;
    }

    .modal-divider,
    .bio-divider {
        width: 50px;
        height: 2px;
        margin: 1.5rem 0;
    }

    .artwork-metadata {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .metadata-item {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .metadata-label {
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        opacity: 0.5;
    }

    .metadata-value {
        font-size: 1rem;
    }

    .artwork-description {
        line-height: 1.7;
        margin-bottom: 2rem;
        font-size: 1.1rem;
    }

    .artwork-context,
    .artwork-acquisition,
    .bio-section {
        margin-top: 2rem;
    }

    .artwork-context h3,
    .artwork-acquisition h3,
    .bio-section h3 {
        font-size: 1.3rem;
        font-weight: 400;
        margin: 0 0 1rem;
    }

    .artwork-acquisition {
        padding-top: 2rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    .artwork-acquisition p {
        margin-bottom: 1.5rem;
    }

    .price-display {
        font-size: 1.2rem;
        margin-bottom: 1.5rem;
    }

    .price-value {
        font-weight: 500;
        font-size: 1.4rem;
    }

    .inquiry-button {
        display: inline-block;
        background: none;
        border: 2px solid;
        padding: 0.8rem 1.5rem;
        text-decoration: none;
        font-size: 0.9rem;
        font-family: inherit;
        cursor: pointer;
        transition: all 0.3s;
        font-weight: 500;
    }

    .inquiry-button:hover {
        background-color: currentColor;
        color: #000 !important;
    }

    .bio-section {
        margin-bottom: 2rem;
    }

    .bio-section p {
        line-height: 1.7;
        font-size: 1.1rem;
    }

    .bio-actions {
        display: flex;
        gap: 1rem;
        margin-top: 3rem;
    }

    .bio-action-btn {
        padding: 0.8rem 1.5rem;
        font-size: 0.9rem;
        font-family: inherit;
        border: none;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-weight: 500;
    }

    .bio-action-btn.outlined {
        background: none;
        border: 2px solid;
    }

    .acquisition-contact {
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    @media (max-width: 1200px) {
        .artist-intro-content {
            grid-template-columns: 1fr;
            gap: 2rem;
        }

        .artist-intro-left {
            order: 2;
        }

        .artist-intro-right {
            order: 1;
            text-align: center;
            align-items: center;
        }

        .artist-bio-button {
            align-self: center;
        }

        .modal-content {
            grid-template-columns: 1fr;
            grid-template-rows: auto auto;
            max-height: 95vh;
        }

        .modal-left,
        .bio-left {
            height: auto;
            max-height: 50vh;
        }

        .modal-right,
        .bio-right {
            max-height: 45vh;
        }
    }

    @media (max-width: 900px) {
        .artwork-section {
            flex-direction: column;
        }

        .artwork-image-container {
            width: 90vw;
            height: 50vh;
        }

        .text-layer {
            justify-content: center;
            align-items: flex-end;
        }

        .artwork-info {
            margin: 0 0 15vh;
            text-align: center;
        }

        .info-divider {
            margin: 1rem auto;
        }

        .artist-name-large {
            font-size: 2.5rem;
        }

        .artist-tagline {
            font-size: 1.2rem;
        }

        .artwork-action-buttons {
            justify-content: center;
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

    @media (max-width: 600px) {
        .artist-name {
            font-size: 2rem;
        }

        .artwork-title {
            font-size: 1.8rem;
        }

        .nav-cue {
            display: none;
        }

        .scroll-indicator {
            right: 1rem;
        }

        .artwork-metadata {
            grid-template-columns: 1fr;
            gap: 1rem;
        }

        .bio-actions {
            flex-direction: column;
        }
    }
    .logo-link {
        text-decoration: none;
        color: inherit;
    }
</style>
