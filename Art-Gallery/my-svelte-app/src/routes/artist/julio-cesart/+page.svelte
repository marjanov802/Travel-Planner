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
    let showCart = false;
    let checkoutStep = 0;

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
            accentColor: "#808080",
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
            accentColor: "#ff80c0",
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
            accentColor: "#4dff4d",
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
            accentColor: "#ff6666",
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
            accentColor: "#b3d9ff",
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
            accentColor: "#ff9966",
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
            accentColor: "#85ff85",
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
        if (isAnimating || artworkDetails || showArtistBio) return;

        clearTimeout(wheelDebounceTimer);
        wheelDebounceTimer = setTimeout(() => {
            const direction = event.deltaY > 0 ? 1 : -1;
            scrollToSection(currentSection + direction);
        }, 50);
    }

    function handleKeydown(event) {
        if (isAnimating || artworkDetails || showArtistBio) return;

        if (event.key === "ArrowDown" || event.key === "PageDown") {
            scrollToSection(currentSection + 1);
        } else if (event.key === "ArrowUp" || event.key === "PageUp") {
            scrollToSection(currentSection - 1);
        } else if (event.key === "Escape") {
            if (artworkDetails) {
                closeArtworkDetails();
            } else if (showArtistBio) {
                closeArtistBio();
            }
        }
    }

    function handleTouchStart(event) {
        touchStartY = event.touches[0].clientY;
    }

    function handleTouchMove(event) {
        if (isAnimating || artworkDetails || showArtistBio) return;

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
        if (artworkDetails || showArtistBio) return;

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
        showCart = !showCart;
        if (showCart) {
            document.body.style.overflow = "hidden";
        } else {
            document.body.style.overflow = "auto";
            checkoutStep = 0;
        }
    }

    function addToCart(artwork, editionType = "Limited Edition Print") {
        const existingItemIndex = cartItems.findIndex(
            (item) =>
                item.id === artwork.id && item.editionType === editionType,
        );

        if (existingItemIndex >= 0) {
            cartItems[existingItemIndex].quantity += 1;
            cartItems = [...cartItems];
        } else {
            const price = getArtworkPrice(artwork, editionType);
            cartItems = [
                ...cartItems,
                {
                    id: artwork.id,
                    title: artwork.title,
                    artist: artist.name,
                    year: artwork.year,
                    imageUrl: artwork.imageUrl,
                    editionType: editionType,
                    price: price,
                    quantity: 1,
                },
            ];
        }

        showCart = true;
    }

    function removeFromCart(index) {
        cartItems = cartItems.filter((_, i) => i !== index);
    }

    function updateQuantity(index, newQuantity) {
        if (newQuantity < 1) return;

        cartItems[index].quantity = newQuantity;
        cartItems = [...cartItems];
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

    function getCartTotal() {
        return cartItems.reduce((total, item) => {
            return total + item.price * item.quantity;
        }, 0);
    }

    function proceedCheckout() {
        if (checkoutStep < 3) {
            checkoutStep += 1;
        }
    }

    function backCheckout() {
        if (checkoutStep > 0) {
            checkoutStep -= 1;
        }
    }

    function completeOrder() {
        checkoutStep = 3;
        setTimeout(() => {
            cartItems = [];
            toggleCart();
        }, 5000);
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

        return () => {
            window.removeEventListener("keydown", handleKeydown);
            window.removeEventListener("mousemove", handleMouseMove);
        };
    });
</script>

<nav class="navbar">
    <div class="left">
        <h1>Marjanov</h1>
    </div>
    <div class="center">
        <ul>
            <li><a href="/" class="nav-link">Discover</a></li>
            <li><a href="/artist" class="nav-link active">Artists</a></li>
        </ul>
    </div>
    <div class="right">
        <div class="basket" on:click={toggleCart}>
            <span class="basket-icon">🛒</span>
            {#if cartItems.length > 0}
                <span class="cart-badge"
                    >{cartItems.reduce(
                        (total, item) => total + item.quantity,
                        0,
                    )}</span
                >
            {/if}
        </div>
    </div>
</nav>

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
    class:visible={initialLoadDone && !artworkDetails && !showArtistBio}
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
    class:no-scroll={isAnimating || artworkDetails || showArtistBio}
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
                        style="border-color: {artist.accentColor}; color: {artist.accentColor};"
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
                        <button
                            class="view-details-btn"
                            style="border-color: {artwork.accentColor}; color: {artwork.accentColor};"
                            on:click={() => openArtworkDetails(artwork)}
                        >
                            View Details
                        </button>
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
                        <h3>Acquisition</h3>
                        <div class="artwork-editions">
                            <div class="edition-item">
                                <div class="edition-info">
                                    <span class="edition-type">Original</span>
                                    <span class="edition-price"
                                        >${getArtworkPrice(
                                            selectedArtwork,
                                            "Original",
                                        ).toLocaleString()}</span
                                    >
                                </div>
                                <button
                                    class="add-to-cart-btn"
                                    style="background-color: {selectedArtwork.accentColor}; color: {selectedArtwork.color}"
                                    on:click={() => {
                                        addToCart(selectedArtwork, "Original");
                                        closeArtworkDetails();
                                    }}
                                >
                                    Add to Cart
                                </button>
                            </div>

                            <div class="edition-item">
                                <div class="edition-info">
                                    <span class="edition-type"
                                        >Limited Edition Print</span
                                    >
                                    <span class="edition-details"
                                        >Edition of 25, signed and numbered</span
                                    >
                                    <span class="edition-price"
                                        >${getArtworkPrice(
                                            selectedArtwork,
                                            "Limited Edition Print",
                                        ).toLocaleString()}</span
                                    >
                                </div>
                                <button
                                    class="add-to-cart-btn"
                                    style="background-color: {selectedArtwork.accentColor}; color: {selectedArtwork.color}"
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
                            </div>

                            <div class="edition-item">
                                <div class="edition-info">
                                    <span class="edition-type"
                                        >Open Edition Print</span
                                    >
                                    <span class="edition-details"
                                        >Museum quality, archival print</span
                                    >
                                    <span class="edition-price"
                                        >${getArtworkPrice(
                                            selectedArtwork,
                                            "Open Edition Print",
                                        ).toLocaleString()}</span
                                    >
                                </div>
                                <button
                                    class="add-to-cart-btn"
                                    style="background-color: {selectedArtwork.accentColor}; color: {selectedArtwork.color}"
                                    on:click={() => {
                                        addToCart(
                                            selectedArtwork,
                                            "Open Edition Print",
                                        );
                                        closeArtworkDetails();
                                    }}
                                >
                                    Add to Cart
                                </button>
                            </div>
                        </div>

                        <div class="acquisition-contact">
                            <p>For custom framing or special requests:</p>
                            <a
                                href="mailto:info@marjanov.com?subject=Inquiry about {selectedArtwork.title}"
                                class="inquiry-button outlined"
                                style="border-color: {selectedArtwork.accentColor}; color: {selectedArtwork.accentColor}"
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
                            style="border-color: {artist.accentColor}; color: {artist.accentColor};"
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
            !showCart}
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

    {#if showCart}
        <div class="cart-modal" transition:fade={{ duration: 300 }}>
            <div class="cart-container">
                <div class="cart-header">
                    <h2>Your Cart</h2>
                    <button class="close-cart-btn" on:click={toggleCart}
                        >×</button
                    >
                </div>

                <div class="cart-content">
                    {#if checkoutStep === 0}
                        {#if cartItems.length === 0}
                            <div class="empty-cart">
                                <svg
                                    width="80"
                                    height="80"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="1"
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
                                <button
                                    class="continue-shopping-btn"
                                    on:click={toggleCart}
                                    >Continue Shopping</button
                                >
                            </div>
                        {:else}
                            <div class="cart-items">
                                {#each cartItems as item, index}
                                    <div class="cart-item">
                                        <div class="cart-item-image">
                                            <img
                                                src={item.imageUrl}
                                                alt={item.title}
                                            />
                                        </div>
                                        <div class="cart-item-details">
                                            <h3>{item.title}</h3>
                                            <p>{item.artist}, {item.year}</p>
                                            <p class="item-edition">
                                                {item.editionType}
                                            </p>
                                            <div class="item-price">
                                                ${item.price.toLocaleString()}
                                            </div>
                                        </div>
                                        <div class="cart-item-actions">
                                            <div class="quantity-selector">
                                                <button
                                                    on:click={() =>
                                                        updateQuantity(
                                                            index,
                                                            item.quantity - 1,
                                                        )}>-</button
                                                >
                                                <span>{item.quantity}</span>
                                                <button
                                                    on:click={() =>
                                                        updateQuantity(
                                                            index,
                                                            item.quantity + 1,
                                                        )}>+</button
                                                >
                                            </div>
                                            <button
                                                class="remove-item-btn"
                                                on:click={() =>
                                                    removeFromCart(index)}
                                                >Remove</button
                                            >
                                        </div>
                                    </div>
                                {/each}
                            </div>

                            <div class="cart-summary">
                                <div class="cart-subtotal">
                                    <span>Subtotal</span>
                                    <span
                                        >${getCartTotal().toLocaleString()}</span
                                    >
                                </div>
                                <div class="cart-shipping">
                                    <span>Shipping</span>
                                    <span>Calculated at checkout</span>
                                </div>
                                <div class="cart-total">
                                    <span>Estimated Total</span>
                                    <span
                                        >${getCartTotal().toLocaleString()}</span
                                    >
                                </div>
                                <button
                                    class="checkout-btn"
                                    on:click={proceedCheckout}
                                    >Proceed to Checkout</button
                                >
                                <button
                                    class="continue-shopping-btn"
                                    on:click={toggleCart}
                                    >Continue Shopping</button
                                >
                            </div>
                        {/if}
                    {:else if checkoutStep === 1}
                        <div class="checkout-step shipping-step">
                            <h3>Shipping Information</h3>
                            <form class="shipping-form">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="firstName">First Name</label
                                        >
                                        <input
                                            type="text"
                                            id="firstName"
                                            required
                                        />
                                    </div>
                                    <div class="form-group">
                                        <label for="lastName">Last Name</label>
                                        <input
                                            type="text"
                                            id="lastName"
                                            required
                                        />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" required />
                                </div>
                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <input type="text" id="address" required />
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="city">City</label>
                                        <input type="text" id="city" required />
                                    </div>
                                    <div class="form-group">
                                        <label for="zipCode">Zip Code</label>
                                        <input
                                            type="text"
                                            id="zipCode"
                                            required
                                        />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="country">Country</label>
                                    <select id="country" required>
                                        <option value="">Select Country</option>
                                        <option value="US">United States</option
                                        >
                                        <option value="UK"
                                            >United Kingdom</option
                                        >
                                        <option value="CA">Canada</option>
                                        <option value="AU">Australia</option>
                                        <option value="FR">France</option>
                                        <option value="DE">Germany</option>
                                        <option value="ES">Spain</option>
                                    </select>
                                </div>
                            </form>

                            <div class="checkout-actions">
                                <button class="back-btn" on:click={backCheckout}
                                    >Back to Cart</button
                                >
                                <button
                                    class="next-btn"
                                    on:click={proceedCheckout}
                                    >Continue to Payment</button
                                >
                            </div>
                        </div>
                    {:else if checkoutStep === 2}
                        <div class="checkout-step payment-step">
                            <h3>Payment Information</h3>
                            <form class="payment-form">
                                <div class="form-group">
                                    <label for="cardName">Name on Card</label>
                                    <input type="text" id="cardName" required />
                                </div>
                                <div class="form-group">
                                    <label for="cardNumber">Card Number</label>
                                    <input
                                        type="text"
                                        id="cardNumber"
                                        placeholder="XXXX XXXX XXXX XXXX"
                                        required
                                    />
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="expiryDate"
                                            >Expiry Date</label
                                        >
                                        <input
                                            type="text"
                                            id="expiryDate"
                                            placeholder="MM/YY"
                                            required
                                        />
                                    </div>
                                    <div class="form-group">
                                        <label for="cvv">CVV</label>
                                        <input
                                            type="text"
                                            id="cvv"
                                            placeholder="XXX"
                                            required
                                        />
                                    </div>
                                </div>
                            </form>

                            <div class="order-summary">
                                <h4>Order Summary</h4>
                                <div class="summary-items">
                                    {#each cartItems as item}
                                        <div class="summary-item">
                                            <span
                                                >{item.quantity}x {item.title} ({item.editionType})</span
                                            >
                                            <span
                                                >${(
                                                    item.price * item.quantity
                                                ).toLocaleString()}</span
                                            >
                                        </div>
                                    {/each}
                                </div>
                                <div class="summary-total">
                                    <span>Total</span>
                                    <span
                                        >${getCartTotal().toLocaleString()}</span
                                    >
                                </div>
                            </div>

                            <div class="checkout-actions">
                                <button class="back-btn" on:click={backCheckout}
                                    >Back to Shipping</button
                                >
                                <button
                                    class="complete-btn"
                                    on:click={completeOrder}
                                    >Complete Purchase</button
                                >
                            </div>
                        </div>
                    {:else if checkoutStep === 3}
                        <div class="checkout-step confirmation-step">
                            <div class="confirmation-icon">
                                <svg
                                    width="80"
                                    height="80"
                                    viewBox="0 0 24 24"
                                    fill="none"
                                    stroke="currentColor"
                                    stroke-width="1"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                >
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"
                                    ></path>
                                    <polyline points="22 4 12 14.01 9 11.01"
                                    ></polyline>
                                </svg>
                            </div>
                            <h3>Order Confirmed!</h3>
                            <p>
                                Thank you for your purchase. Your order has been
                                received and is being processed.
                            </p>
                            <p>
                                A confirmation email with your order details has
                                been sent to your email address.
                            </p>
                            <p class="delivery-note">
                                For original artworks and limited editions, our
                                gallery will contact you within 24 hours to
                                arrange delivery and provide tracking
                                information.
                            </p>
                            <button
                                class="continue-shopping-btn"
                                on:click={toggleCart}>Return to Gallery</button
                            >
                        </div>
                    {/if}
                </div>
            </div>
        </div>
    {/if}
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
        background: rgba(0, 0, 0, 0.5);
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
        background: rgba(255, 255, 255, 0.1);
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
        border: 1px solid;
        padding: 0.8rem 1.5rem;
        font-size: 1rem;
        font-family: inherit;
        cursor: pointer;
        transition:
            background-color 0.3s,
            color 0.3s;
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

    .view-details-btn {
        background: none;
        border: 1px solid;
        padding: 0.8rem 1.5rem;
        font-size: 0.9rem;
        font-family: inherit;
        cursor: pointer;
        transition:
            background-color 0.3s,
            color 0.3s;
    }

    .view-details-btn:hover {
        background-color: currentColor;
        color: #000 !important;
    }

    .section-counter {
        position: absolute;
        bottom: 2rem;
        left: 2rem;
        font-size: 1rem;
        opacity: 0.7;
        z-index: 4;
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
        background-color: rgba(0, 0, 0, 0.5);
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

    .inquiry-button {
        display: inline-block;
        padding: 0.8rem 1.5rem;
        text-decoration: none;
        font-size: 0.9rem;
        font-family: inherit;
        border: none;
        cursor: pointer;
        transition: opacity 0.3s;
    }

    .inquiry-button:hover {
        opacity: 0.9;
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
    }

    .bio-action-btn.outlined {
        background: none;
        border: 1px solid;
    }

    .basket {
        position: relative;
    }

    .cart-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: #ff4444;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.8rem;
        font-weight: bold;
    }

    .cart-modal {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.8);
        backdrop-filter: blur(5px);
        z-index: 1000;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .cart-container {
        width: 90%;
        max-width: 900px;
        max-height: 90vh;
        background-color: #111111;
        border-radius: 8px;
        overflow: hidden;
        display: flex;
        flex-direction: column;
    }

    .cart-header {
        padding: 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .cart-header h2 {
        margin: 0;
        font-size: 1.8rem;
        font-weight: 400;
    }

    .close-cart-btn {
        background: none;
        border: none;
        color: white;
        font-size: 2rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        opacity: 0.7;
        transition: opacity 0.3s;
    }

    .close-cart-btn:hover {
        opacity: 1;
    }

    .cart-content {
        flex: 1;
        overflow-y: auto;
        padding: 1.5rem;
    }

    .empty-cart {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 3rem 0;
        color: rgba(255, 255, 255, 0.7);
    }

    .empty-cart p {
        margin: 1rem 0 2rem;
        font-size: 1.2rem;
    }

    .cart-items {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .cart-item {
        display: grid;
        grid-template-columns: 100px 1fr auto;
        gap: 1.5rem;
        padding-bottom: 1.5rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .cart-item-image {
        width: 100px;
        height: 100px;
        overflow: hidden;
        border-radius: 4px;
    }

    .cart-item-image img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .cart-item-details {
        display: flex;
        flex-direction: column;
    }

    .cart-item-details h3 {
        margin: 0 0 0.5rem;
        font-size: 1.2rem;
        font-weight: 400;
    }

    .cart-item-details p {
        margin: 0 0 0.5rem;
        opacity: 0.7;
        font-size: 0.9rem;
    }

    .item-edition {
        font-style: italic;
    }

    .item-price {
        font-weight: 500;
        margin-top: auto;
    }

    .cart-item-actions {
        display: flex;
        flex-direction: column;
        align-items: flex-end;
        justify-content: space-between;
    }

    .quantity-selector {
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .quantity-selector button {
        width: 30px;
        height: 30px;
        background: rgba(255, 255, 255, 0.1);
        border: none;
        border-radius: 4px;
        color: white;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: background-color 0.3s;
    }

    .quantity-selector button:hover {
        background: rgba(255, 255, 255, 0.2);
    }

    .remove-item-btn {
        background: none;
        border: none;
        color: rgba(255, 255, 255, 0.6);
        font-size: 0.9rem;
        cursor: pointer;
        padding: 0.5rem;
        transition: color 0.3s;
    }

    .remove-item-btn:hover {
        color: white;
        text-decoration: underline;
    }

    .cart-summary {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 1.5rem;
    }

    .cart-subtotal,
    .cart-shipping,
    .cart-total {
        display: flex;
        justify-content: space-between;
        margin-bottom: 1rem;
    }

    .cart-total {
        font-size: 1.2rem;
        font-weight: 500;
        padding-top: 1rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
        margin-top: 1rem;
    }

    .checkout-btn,
    .continue-shopping-btn {
        width: 100%;
        padding: 1rem;
        border: none;
        border-radius: 4px;
        font-family: inherit;
        font-size: 1rem;
        cursor: pointer;
        transition: opacity 0.3s;
        margin-top: 1rem;
    }

    .checkout-btn {
        background: #3a86ff;
        color: white;
    }

    .continue-shopping-btn {
        background: none;
        border: 1px solid rgba(255, 255, 255, 0.3);
        color: white;
    }

    .checkout-btn:hover,
    .continue-shopping-btn:hover {
        opacity: 0.9;
    }

    .checkout-step {
        max-width: 600px;
        margin: 0 auto;
    }

    .checkout-step h3 {
        margin: 0 0 2rem;
        font-size: 1.5rem;
        font-weight: 400;
        text-align: center;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
    }

    .form-group {
        margin-bottom: 1.5rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
        opacity: 0.7;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 0.8rem 1rem;
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 4px;
        color: white;
        font-family: inherit;
        font-size: 1rem;
    }

    .form-group input:focus,
    .form-group select:focus {
        outline: none;
        border-color: #3a86ff;
    }

    .checkout-actions {
        display: flex;
        justify-content: space-between;
        margin-top: 2rem;
    }

    .back-btn,
    .next-btn,
    .complete-btn {
        padding: 0.8rem 1.5rem;
        border-radius: 4px;
        font-family: inherit;
        font-size: 1rem;
        cursor: pointer;
        transition: opacity 0.3s;
    }

    .back-btn {
        background: none;
        border: 1px solid rgba(255, 255, 255, 0.3);
        color: white;
    }

    .next-btn,
    .complete-btn {
        background: #3a86ff;
        color: white;
        border: none;
    }

    .order-summary {
        margin-top: 2rem;
        padding: 1.5rem;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
    }

    .order-summary h4 {
        margin: 0 0 1rem;
        font-size: 1.2rem;
        font-weight: 400;
    }

    .summary-items {
        margin-bottom: 1.5rem;
    }

    .summary-item {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        font-size: 0.9rem;
    }

    .summary-total {
        display: flex;
        justify-content: space-between;
        font-weight: 500;
        padding-top: 1rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    .confirmation-step {
        text-align: center;
        padding: 2rem 0;
    }

    .confirmation-icon {
        margin-bottom: 2rem;
        color: #4bb543;
    }

    .confirmation-step p {
        margin-bottom: 1.5rem;
        max-width: 500px;
        margin-left: auto;
        margin-right: auto;
    }

    .delivery-note {
        font-style: italic;
        opacity: 0.7;
        border-left: 2px solid #3a86ff;
        padding-left: 1rem;
        text-align: left;
        margin: 2rem auto;
    }

    .artwork-editions {
        display: flex;
        flex-direction: column;
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    .edition-item {
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 1.2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .edition-info {
        display: flex;
        flex-direction: column;
        gap: 0.3rem;
    }

    .edition-type {
        font-weight: 500;
        font-size: 1.1rem;
    }

    .edition-details {
        font-size: 0.9rem;
        opacity: 0.7;
    }

    .edition-price {
        font-weight: 500;
        font-size: 1.2rem;
        margin-top: 0.5rem;
    }

    .add-to-cart-btn {
        padding: 0.7rem 1.2rem;
        border: none;
        border-radius: 4px;
        font-family: inherit;
        font-size: 0.9rem;
        cursor: pointer;
        white-space: nowrap;
    }

    .acquisition-contact {
        margin-top: 2rem;
        padding-top: 1.5rem;
        border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    .inquiry-button.outlined {
        background: none;
        border: 1px solid;
        padding: 0.8rem 1.5rem;
        display: inline-block;
        text-decoration: none;
        transition:
            background-color 0.3s,
            color 0.3s;
        margin-top: 1rem;
    }

    .inquiry-button.outlined:hover {
        background-color: currentColor;
        color: #000 !important;
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

        .edition-item {
            flex-direction: column;
            align-items: flex-start;
            gap: 1rem;
        }

        .add-to-cart-btn {
            width: 100%;
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

        .cart-item {
            grid-template-columns: 80px 1fr;
            grid-template-rows: auto auto;
            gap: 1rem;
        }

        .cart-item-actions {
            grid-column: 1 / span 2;
            flex-direction: row;
            justify-content: space-between;
            align-items: center;
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
</style>
