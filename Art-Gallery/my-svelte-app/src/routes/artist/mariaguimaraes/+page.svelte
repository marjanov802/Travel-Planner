<script>
    import { onMount } from "svelte";

    let navDark = false;
    let isLoaded = false;
    let activeArtworkIndex = 0;
    let draggedArtworkIndex = null;
    let initialMousePos = { x: 0, y: 0 };
    let artworkPositions = [];
    let mouseX = 0;
    let mouseY = 0;
    let viewMode = "experience";
    let activeSection = null;
    let wavesAnimation;
    let contactFormData = { name: "", email: "", message: "" };
    let formSubmitted = false;
    let formSubmitting = false;
    let showArtworkDetails = false;
    let activeColorIndex = null;
    let isDraggable = true;
    let isGridView = false;
    let wasDragging = false;

    let cartItems = [];
    let cartCount = 0;
    let isCartOpen = false;
    let showAddedNotification = false;
    let lastAddedItem = null;

    const palette = [
        { name: "Ocean Teal", hex: "#00A99D" },
        { name: "Vibrant Coral", hex: "#FF6B6B" },
        { name: "Sunlit Gold", hex: "#FFD166" },
        { name: "Deep Indigo", hex: "#4A3DE8" },
        { name: "Fresh Mint", hex: "#06D6A0" },
    ];

    const artist = {
        name: "Maria Guimaraes",
        title: "Color Alchemist",
        bio: "Maria Guimaraes Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        longBio:
            "Maria Guimaraes Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        approach:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        portrait: "/images/mariaguimaraes/maria.jpg",
        exhibitions: [
            {
                title: "Chromatic Reveries",
                venue: "MoMA PS1, New York",
                year: "2023",
            },
            {
                title: "Color Fields Reimagined",
                venue: "Tate Modern, London",
                year: "2022",
            },
            {
                title: "Sensory Landscapes",
                venue: "Museo Reina Sofía, Madrid",
                year: "2021",
            },
            {
                title: "Vibration Theory",
                venue: "Palais de Tokyo, Paris",
                year: "2020",
            },
        ],
    };

    const artworks = [
        {
            id: 1,
            title: "Vibrant Echoes",
            year: "2023",
            colors: [palette[0], palette[3], palette[1]],
            src: "/images/mariaguimaraes/1.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 2,
            title: "Urban Symphony",
            year: "2022",
            colors: [palette[1], palette[2], palette[0]],
            src: "/images/mariaguimaraes/2.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 3,
            title: "Serenity Flow",
            year: "2023",
            colors: [palette[0], palette[4], palette[2]],
            src: "/images/mariaguimaraes/3.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 4,
            title: "Fractured Light",
            year: "2021",
            colors: [palette[2], palette[3], palette[1]],
            src: "/images/mariaguimaraes/4.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 5,
            title: "Emotional Landscape",
            year: "2022",
            colors: [palette[4], palette[1], palette[3]],
            src: "/images/mariaguimaraes/5.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 6,
            title: "Chromatic Dreams",
            year: "2023",
            colors: [palette[3], palette[2], palette[4]],
            src: "/images/mariaguimaraes/6.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
        {
            id: 7,
            title: "Structural Harmony",
            year: "2021",
            colors: [palette[0], palette[1], palette[4]],
            src: "/images/mariaguimaraes/7.jpg",
            description:
                "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. ",
        },
    ];

    // Cart functions
    function toggleCart() {
        isCartOpen = !isCartOpen;
    }

    function addToCart(artwork) {
        const item = {
            id: Date.now(),
            src: artwork.src,
            artist: artist.name,
            title: artwork.title,
            size: '24" x 36"',
            medium: "Oil on Canvas",
            year: artwork.year,
            price: 1200,
        };

        cartItems = [...cartItems, item];
        cartCount = cartItems.length;

        // Store in local storage
        localStorage.setItem("artworkCart", JSON.stringify(cartItems));

        lastAddedItem = item;
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

    function handleMouseMove(event) {
        mouseX = event.clientX;
        mouseY = event.clientY;

        document.documentElement.style.setProperty(
            "--mouse-x",
            `${(mouseX / window.innerWidth) * 100}%`,
        );
        document.documentElement.style.setProperty(
            "--mouse-y",
            `${(mouseY / window.innerHeight) * 100}%`,
        );

        if (draggedArtworkIndex !== null) {
            wasDragging = true;
            const deltaX = event.clientX - initialMousePos.x;
            const deltaY = event.clientY - initialMousePos.y;

            artworkPositions[draggedArtworkIndex].x += deltaX;
            artworkPositions[draggedArtworkIndex].y += deltaY;

            const minX = 0;
            const minY = 80;
            const maxX = window.innerWidth - 250;
            const maxY = window.innerHeight - 250;

            artworkPositions[draggedArtworkIndex].x = Math.max(
                minX,
                Math.min(maxX, artworkPositions[draggedArtworkIndex].x),
            );
            artworkPositions[draggedArtworkIndex].y = Math.max(
                minY,
                Math.min(maxY, artworkPositions[draggedArtworkIndex].y),
            );

            initialMousePos = { x: event.clientX, y: event.clientY };

            artworkPositions = [...artworkPositions];
        }
    }

    function startDrag(index, event) {
        if (!isDraggable) return;

        draggedArtworkIndex = index;
        wasDragging = false;
        initialMousePos = { x: event.clientX, y: event.clientY };
        event.stopPropagation();
    }

    function endDrag() {
        draggedArtworkIndex = null;
        setTimeout(() => {
            wasDragging = false;
        }, 100);
    }

    function handleArtworkClick(index) {
        if (!wasDragging) {
            setActiveArtwork(index);
        }
    }

    function setActiveArtwork(index) {
        activeArtworkIndex = index;
        showArtworkDetails = true;
        activeSection = null;
        updateColorWaves();
    }

    function closeArtworkDetails() {
        showArtworkDetails = false;
    }

    function showSection(section) {
        activeSection = section;
        showArtworkDetails = false;

        if (section === "contact") {
            formSubmitted = false;
        }
    }

    function changeViewMode(mode) {
        viewMode = mode;
        activeSection = null;
        showArtworkDetails = false;
        isGridView = false;
    }

    function toggleColorHighlight(index) {
        if (activeColorIndex === index) {
            activeColorIndex = null;
        } else {
            activeColorIndex = index;
        }
    }

    function prevArtwork() {
        if (activeArtworkIndex > 0) {
            activeArtworkIndex--;
            updateColorWaves();
        }
    }

    function nextArtwork() {
        if (activeArtworkIndex < artworks.length - 1) {
            activeArtworkIndex++;
            updateColorWaves();
        }
    }

    function randomizePositions() {
        artworkPositions = artworks.map(() => ({
            x: Math.random() * (window.innerWidth - 300) + 50,
            y: Math.random() * (window.innerHeight - 400) + 100,
        }));
    }

    function organizeGrid() {
        const gridCols = 3;
        const gridRows = Math.ceil(artworks.length / gridCols);

        const cellWidth = Math.min(300, (window.innerWidth - 100) / gridCols);
        const cellHeight = Math.min(300, (window.innerHeight - 200) / gridRows);

        const startX = (window.innerWidth - cellWidth * gridCols) / 2;
        const startY = 120;

        artworkPositions = artworks.map((_, index) => {
            const row = Math.floor(index / gridCols);
            const col = index % gridCols;
            return {
                x: startX + col * cellWidth,
                y: startY + row * cellHeight,
            };
        });

        isGridView = true;
    }

    function toggleDragging() {
        isDraggable = !isDraggable;
    }

    function updateColorWaves() {
        const activeColors = artworks[activeArtworkIndex].colors;

        wavesAnimation &&
            wavesAnimation.particles.forEach((particle, index) => {
                if (index % 3 === 0) {
                    particle.color = activeColors[0].hex;
                } else if (index % 3 === 1) {
                    particle.color = activeColors[1].hex;
                } else {
                    particle.color = activeColors[2].hex;
                }
            });
    }

    function handleContactSubmit() {
        formSubmitting = true;

        setTimeout(() => {
            formSubmitting = false;
            formSubmitted = true;

            contactFormData = { name: "", email: "", message: "" };
        }, 1500);
    }

    function initializeWaves() {
        const canvas = document.getElementById("waves-canvas");
        const ctx = canvas.getContext("2d");

        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        class Particle {
            constructor(x, y, color, size, speed) {
                this.x = x;
                this.y = y;
                this.color = color;
                this.size = size;
                this.speed = speed;
                this.angle = Math.random() * 2 * Math.PI;
                this.amplitude = Math.random() * 50 + 30;
                this.frequency = Math.random() * 0.02 + 0.01;
                this.baseY = y;
            }

            update() {
                this.angle += this.speed;
                this.y = this.baseY + Math.sin(this.angle) * this.amplitude;
            }

            draw() {
                ctx.fillStyle = this.color;
                ctx.beginPath();
                ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
                ctx.fill();
            }
        }

        const particles = [];
        const activeColors = artworks[activeArtworkIndex].colors.map(
            (c) => c.hex,
        );

        for (let i = 0; i < 60; i++) {
            const size = Math.random() * 30 + 20;
            const x = Math.random() * canvas.width;
            const y = Math.random() * canvas.height;
            const speed = Math.random() * 0.01 + 0.005;
            const colorIndex = i % 3;

            particles.push(
                new Particle(x, y, activeColors[colorIndex], size, speed),
            );
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            ctx.globalCompositeOperation = "multiply";

            particles.forEach((particle) => {
                particle.update();
                particle.draw();
            });

            requestAnimationFrame(animate);
        }

        animate();

        wavesAnimation = { particles };

        window.addEventListener("resize", () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            if (isGridView) {
                organizeGrid();
            }
        });
    }

    function handleKeydown(event) {
        if (showArtworkDetails) {
            if (event.key === "Escape") {
                closeArtworkDetails();
            } else if (event.key === "ArrowLeft") {
                prevArtwork();
            } else if (event.key === "ArrowRight") {
                nextArtwork();
            }
        }
    }

    onMount(() => {
        setTimeout(() => {
            isLoaded = true;
            randomizePositions();
            initializeWaves();

            // Load cart from localStorage
            const savedCart = localStorage.getItem("artworkCart");
            if (savedCart) {
                cartItems = JSON.parse(savedCart);
                cartCount = cartItems.length;
            }
        }, 2000);

        window.addEventListener("mouseup", endDrag);
        window.addEventListener("mousemove", handleMouseMove);
        window.addEventListener("keydown", handleKeydown);

        return () => {
            window.removeEventListener("mouseup", endDrag);
            window.removeEventListener("mousemove", handleMouseMove);
            window.removeEventListener("keydown", handleKeydown);
        };
    });
</script>

{#if !isLoaded}
    <div class="loading-screen">
        <div class="loading-artist">{artist.name}</div>
        <div class="loading-colors">
            {#each palette as color}
                <div
                    class="loading-color"
                    style="background-color: {color.hex}"
                ></div>
            {/each}
        </div>
        <div class="loading-subtitle">Preparing Color Experience</div>
    </div>
{/if}

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
                <button class="checkout-button">Proceed to Checkout</button>
            </div>
        {/if}
    </div>
{/if}

<div class="experience-controls">
    <button
        class="control-button {viewMode === 'experience' ? 'active' : ''}"
        on:click={() => changeViewMode("experience")}
    >
        <span class="icon">🎨</span>
        <span class="label">Experience</span>
    </button>

    <button
        class="control-button {viewMode === 'gallery' ? 'active' : ''}"
        on:click={() => changeViewMode("gallery")}
    >
        <span class="icon">🖼️</span>
        <span class="label">Gallery</span>
    </button>
</div>

<div class="artist-nav">
    <button class="artist-nav-button" on:click={() => showSection("artist")}>
        <span class="icon">👩‍🎨</span>
        <span class="label">Artist</span>
    </button>
    <button class="artist-nav-button" on:click={() => showSection("contact")}>
        <span class="icon">✉️</span>
        <span class="label">Contact</span>
    </button>
</div>

{#if viewMode === "experience"}
    <div class="organization-controls">
        <button
            class="org-button"
            on:click={randomizePositions}
            title="Randomize Positions"
        >
            <span class="icon">🔀</span>
        </button>
        <button
            class="org-button"
            on:click={organizeGrid}
            title="Organize in Grid"
        >
            <span class="icon">📊</span>
        </button>
        <button
            class="org-button {isDraggable ? 'active' : ''}"
            on:click={toggleDragging}
            title={isDraggable ? "Disable Dragging" : "Enable Dragging"}
        >
            <span class="icon">✋</span>
        </button>
    </div>
{/if}

<canvas id="waves-canvas" class="color-canvas"></canvas>

{#if viewMode === "experience"}
    <div class="experience-container">
        {#each artworks as artwork, i}
            <div
                class="floating-artwork {i === activeArtworkIndex
                    ? 'active'
                    : ''} {isDraggable ? 'draggable' : ''}"
                style="transform: translate({artworkPositions[i]?.x ||
                    0}px, {artworkPositions[i]?.y || 0}px)"
                on:mousedown={(e) => startDrag(i, e)}
            >
                <div class="artwork-frame">
                    <img
                        src={artwork.src}
                        alt={artwork.title}
                        draggable="false"
                        on:click={() => handleArtworkClick(i)}
                    />
                    {#if isDraggable}
                        <div class="drag-handle" title="Drag to reposition">
                            <svg viewBox="0 0 24 24" width="24" height="24">
                                <path
                                    d="M10 9h4V6h3l-5-5-5 5h3v3zm-1 1H6V7l-5 5 5 5v-3h3v-4zm14 2l-5-5v3h-3v4h3v3l5-5zm-9 3h-4v3H7l5 5 5-5h-3v-3z"
                                    fill="currentColor"
                                />
                            </svg>
                        </div>
                    {/if}
                    <div class="click-hint">Click to view</div>
                </div>
            </div>
        {/each}
    </div>
{/if}

{#if viewMode === "gallery"}
    <div class="gallery-container">
        <div class="gallery-header">
            <h1>{artist.name}</h1>
            <div class="artist-title">{artist.title}</div>
        </div>

        <div class="gallery-grid">
            {#each artworks as artwork, i}
                <div
                    class="gallery-item {i === activeArtworkIndex
                        ? 'active'
                        : ''}"
                    on:click={() => setActiveArtwork(i)}
                >
                    <img src={artwork.src} alt={artwork.title} />
                    <div class="artwork-colors">
                        {#each artwork.colors as color}
                            <div
                                class="color-dot"
                                style="background-color: {color.hex}"
                            ></div>
                        {/each}
                    </div>
                    <div class="click-hint">Click to view</div>
                </div>
            {/each}
        </div>
    </div>
{/if}

{#if showArtworkDetails}
    <div class="immersive-view" on:click={closeArtworkDetails}>
        <div class="artwork-container" on:click|stopPropagation>
            <div class="artwork-view">
                <img
                    src={artworks[activeArtworkIndex].src}
                    alt={artworks[activeArtworkIndex].title}
                    class="artwork-image {activeColorIndex !== null
                        ? 'color-highlight'
                        : ''}"
                />

                {#each artworks[activeArtworkIndex].colors as color, i}
                    <div
                        class="color-hotspot {activeColorIndex === i
                            ? 'active'
                            : ''}"
                        style="
                            top: {30 + i * 20}%; 
                            left: {i === 0 ? 15 : i === 1 ? 50 : 85}%;
                            background-color: {color.hex};
                        "
                        on:click={() => toggleColorHighlight(i)}
                        title={color.name}
                    >
                        {#if activeColorIndex === i}
                            <div class="color-info">
                                <span class="color-name">{color.name}</span>
                                <span class="color-hex">{color.hex}</span>
                            </div>
                        {/if}
                    </div>
                {/each}

                <div class="artwork-info-overlay">
                    <div class="artwork-title-info">
                        <h2>{artworks[activeArtworkIndex].title}</h2>
                        <p>{artworks[activeArtworkIndex].year}</p>
                    </div>

                    <div class="artwork-nav">
                        <button
                            class="artwork-nav-btn prev"
                            on:click|stopPropagation={prevArtwork}
                            disabled={activeArtworkIndex === 0}
                        >
                            ←
                        </button>

                        <span class="artwork-counter"
                            >{activeArtworkIndex + 1} / {artworks.length}</span
                        >

                        <button
                            class="artwork-nav-btn next"
                            on:click|stopPropagation={nextArtwork}
                            disabled={activeArtworkIndex ===
                                artworks.length - 1}
                        >
                            →
                        </button>
                    </div>

                    <div class="artwork-actions">
                        <button
                            class="artwork-action-btn add-cart-btn"
                            on:click|stopPropagation={() =>
                                addToCart(artworks[activeArtworkIndex])}
                        >
                            Add to Cart
                        </button>
                        <button
                            class="artwork-action-btn info-btn"
                            on:click|stopPropagation={() =>
                                showSection("artist")}
                        >
                            About Artist
                        </button>
                        <button
                            class="artwork-action-btn contact-btn"
                            on:click|stopPropagation={() =>
                                showSection("contact")}
                        >
                            Inquire
                        </button>
                    </div>
                </div>

                <button class="artwork-close" on:click={closeArtworkDetails}
                    >×</button
                >
            </div>
        </div>
    </div>
{/if}

{#if activeSection === "artist"}
    <div class="modal-panel artist-panel">
        <button class="close-panel" on:click={() => (activeSection = null)}
            >×</button
        >

        <div class="minimal-panel">
            <div class="panel-grid">
                <div class="panel-sidebar">
                    <div class="artist-portrait">
                        <img src={artist.portrait} alt={artist.name} />
                    </div>

                    <h1>{artist.name}</h1>
                    <div class="artist-title">{artist.title}</div>

                    <div class="artist-palette-mini">
                        {#each palette as color}
                            <span
                                class="palette-chip"
                                style="background-color: {color.hex}"
                            ></span>
                        {/each}
                    </div>

                    <div class="artist-exhibitions-mini">
                        <h3>Recent Exhibitions</h3>
                        <ul>
                            {#each artist.exhibitions as exhibition}
                                <li>
                                    <span class="year">{exhibition.year}</span>
                                    <span class="venue">{exhibition.venue}</span
                                    >
                                </li>
                            {/each}
                        </ul>
                    </div>

                    <button
                        class="inquire-button"
                        on:click={() => showSection("contact")}
                    >
                        Inquire
                    </button>
                </div>

                <div class="panel-main">
                    <div class="bio-content">
                        {#each artist.longBio.split("\n\n") as paragraph}
                            <p>{paragraph}</p>
                        {/each}

                        <blockquote>
                            {artist.approach}
                        </blockquote>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/if}

{#if activeSection === "contact"}
    <div class="modal-panel contact-panel">
        <button class="close-panel" on:click={() => (activeSection = null)}
            >×</button
        >

        <div class="minimal-panel">
            <h2 class="panel-heading">Inquire</h2>

            {#if formSubmitted}
                <div class="form-success-minimal">
                    <div class="success-icon">✓</div>
                    <p>Thank you for your inquiry.</p>
                    <p>We will respond within 24 hours.</p>
                    <button
                        class="action-button-minimal"
                        on:click={() => (activeSection = null)}
                    >
                        Return to Gallery
                    </button>
                </div>
            {:else}
                <div class="contact-columns-minimal">
                    <form
                        class="contact-form-minimal"
                        on:submit|preventDefault={handleContactSubmit}
                    >
                        <div class="form-row">
                            <div class="form-group-minimal">
                                <label for="name">Name</label>
                                <input
                                    type="text"
                                    id="name"
                                    bind:value={contactFormData.name}
                                    required
                                    disabled={formSubmitting}
                                />
                            </div>

                            <div class="form-group-minimal">
                                <label for="email">Email</label>
                                <input
                                    type="email"
                                    id="email"
                                    bind:value={contactFormData.email}
                                    required
                                    disabled={formSubmitting}
                                />
                            </div>
                        </div>

                        <div class="form-group-minimal">
                            <label for="message">Message</label>
                            <textarea
                                id="message"
                                bind:value={contactFormData.message}
                                rows="4"
                                required
                                disabled={formSubmitting}
                                placeholder="How can we assist you?"
                            ></textarea>
                        </div>

                        <div class="form-row checkbox-row">
                            <label class="checkbox-label-minimal">
                                <input
                                    type="checkbox"
                                    disabled={formSubmitting}
                                />
                                <span>Purchase</span>
                            </label>
                            <label class="checkbox-label-minimal">
                                <input
                                    type="checkbox"
                                    disabled={formSubmitting}
                                />
                                <span>Commission</span>
                            </label>
                            <label class="checkbox-label-minimal">
                                <input
                                    type="checkbox"
                                    disabled={formSubmitting}
                                />
                                <span>Exhibition</span>
                            </label>
                        </div>

                        <button
                            type="submit"
                            class="submit-button-minimal {formSubmitting
                                ? 'submitting'
                                : ''}"
                            disabled={formSubmitting}
                        >
                            {#if formSubmitting}
                                <span class="spinner"></span>
                                Sending
                            {:else}
                                Send
                            {/if}
                        </button>
                    </form>

                    <div class="contact-info-minimal">
                        <div class="contact-method-minimal">
                            <span class="contact-label">Location</span>
                            <p>123 Art Avenue, Barcelona, Spain</p>
                        </div>

                        <div class="contact-method-minimal">
                            <span class="contact-label">Gallery Hours</span>
                            <p>Tuesday–Saturday: 10am–6pm</p>
                            <p>Sunday: By appointment</p>
                        </div>

                        <div class="contact-method-minimal">
                            <span class="contact-label">Contact</span>
                            <p>+34 912 345 678</p>
                            <p>gallery@marjanov.com</p>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    </div>
{/if}

<style lang="css">
    @import url("https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=Raleway:wght@300;400;600&display=swap");

    :root {
        --primary-color: #00a99d;
        --secondary-color: #ff6b6b;
        --accent-color: #ffd166;
        --dark-color: #4a3de8;
        --light-color: #06d6a0;
        --background: rgba(255, 255, 255, 0.8);
        --text: #222;
        --mouse-x: 50%;
        --mouse-y: 50%;
    }

    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    :global(body) {
        font-family: "Raleway", sans-serif;
        color: var(--text);
        overflow: hidden;
        background-color: #f8f8f8;
    }

    .loading-screen {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: black;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 2000;
        color: white;
    }

    .loading-artist {
        font-family: "Cinzel", serif;
        font-size: 4rem;
        margin-bottom: 20px;
        letter-spacing: 3px;
    }

    .loading-colors {
        display: flex;
        gap: 15px;
        margin-bottom: 30px;
    }

    .loading-color {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        animation: pulse 1.5s infinite alternate;
    }

    .loading-color:nth-child(1) {
        animation-delay: 0s;
    }
    .loading-color:nth-child(2) {
        animation-delay: 0.3s;
    }
    .loading-color:nth-child(3) {
        animation-delay: 0.6s;
    }
    .loading-color:nth-child(4) {
        animation-delay: 0.9s;
    }
    .loading-color:nth-child(5) {
        animation-delay: 1.2s;
    }

    @keyframes pulse {
        0% {
            transform: scale(1);
        }
        100% {
            transform: scale(1.5);
        }
    }

    .loading-subtitle {
        font-size: 1rem;
        letter-spacing: 2px;
        opacity: 0.7;
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
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border-bottom: 1px solid rgba(204, 204, 204, 0.3);
        z-index: 1000;
        transition: all 0.3s;
    }
    .left h1 {
        margin: 0;
        font-size: 2rem;
        font-weight: bold;
        text-transform: uppercase;
        color: #333;
    }

    .logo-link {
        text-decoration: none;
        color: inherit;
    }

    .navbar.dark .logo-link {
        color: white;
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

    /* Basket and Cart Styles */
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

    .navbar.dark .basket-icon {
        color: #fff;
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

    .cart-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1600;
    }

    .cart-sidebar {
        position: fixed;
        top: 0;
        right: 0;
        width: 350px;
        height: 100%;
        background: white;
        z-index: 1700;
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

    .added-notification {
        position: fixed;
        top: 20px;
        right: 20px;
        width: 320px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        z-index: 1800;
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

    .navbar.dark {
        background: rgba(0, 0, 0, 0.8);
        border-bottom-color: rgba(255, 255, 255, 0.1);
    }

    .navbar.dark .left h1,
    .navbar.dark .nav-link,
    .navbar.dark .basket-icon {
        color: #fff;
    }

    .color-canvas {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: -1;
    }

    .experience-controls {
        position: fixed;
        bottom: 30px;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        gap: 15px;
        z-index: 100;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border-radius: 30px;
        padding: 10px 15px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
    }

    .organization-controls {
        position: fixed;
        bottom: 30px;
        right: 30px;
        display: flex;
        flex-direction: column;
        gap: 15px;
        z-index: 100;
    }

    .org-button {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        transition: all 0.3s;
    }

    .org-button:hover {
        transform: scale(1.1);
    }

    .org-button.active {
        background-color: rgba(0, 169, 157, 0.2);
        color: var(--primary-color);
    }

    .org-button .icon {
        font-size: 1.5rem;
    }

    .artist-nav {
        position: fixed;
        top: 100px;
        right: 30px;
        display: flex;
        flex-direction: column;
        gap: 15px;
        z-index: 100;
    }

    .artist-nav-button {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: none;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        transition: all 0.3s;
        position: relative;
    }

    .artist-nav-button:hover {
        transform: scale(1.1);
    }

    .artist-nav-button .icon {
        font-size: 1.2rem;
    }

    .artist-nav-button .label {
        position: absolute;
        right: 60px;
        background: rgba(255, 255, 255, 0.9);
        padding: 5px 10px;
        border-radius: 4px;
        font-size: 0.8rem;
        opacity: 0;
        pointer-events: none;
        transition: all 0.3s;
        white-space: nowrap;
    }

    .artist-nav-button:hover .label {
        opacity: 1;
        transform: translateX(-5px);
    }

    .control-button {
        background: none;
        border: none;
        padding: 8px 12px;
        border-radius: 20px;
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        transition: all 0.3s;
        color: #333;
    }

    .control-button:hover,
    .control-button.active {
        background-color: rgba(0, 0, 0, 0.1);
    }

    .control-button .icon {
        font-size: 1.2rem;
    }

    .control-button .label {
        font-size: 0.9rem;
    }

    .experience-container {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 1;
    }

    .floating-artwork {
        position: absolute;
        transform-origin: center center;
        transition:
            box-shadow 0.3s,
            transform 0.1s;
        z-index: 10;
    }

    .floating-artwork.draggable {
        cursor: grab;
    }

    .floating-artwork.draggable:active {
        cursor: grabbing;
    }

    .floating-artwork.active {
        z-index: 20;
    }

    .artwork-frame {
        width: 250px;
        height: 250px;
        overflow: hidden;
        border-radius: 2px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        transform: rotate(-5deg);
        transition: transform 0.3s;
        background-color: white;
        padding: 10px;
        position: relative;
    }

    .floating-artwork:hover .artwork-frame {
        transform: rotate(0deg) scale(1.05);
    }

    .floating-artwork.active .artwork-frame {
        transform: rotate(0deg) scale(1.1);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
    }

    .artwork-frame img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        cursor: pointer;
    }

    .drag-handle {
        position: absolute;
        top: 15px;
        right: 15px;
        width: 30px;
        height: 30px;
        background: rgba(0, 0, 0, 0.5);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        cursor: grab;
        opacity: 0;
        transition: opacity 0.3s;
        z-index: 5;
    }

    .floating-artwork:hover .drag-handle {
        opacity: 0.8;
    }

    .drag-handle:hover {
        opacity: 1 !important;
        transform: scale(1.1);
    }

    .click-hint {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 8px;
        text-align: center;
        font-size: 0.8rem;
        transform: translateY(100%);
        transition: transform 0.3s;
    }

    .floating-artwork:hover .click-hint,
    .gallery-item:hover .click-hint {
        transform: translateY(0);
    }

    .gallery-container {
        position: relative;
        padding: 100px 5% 50px;
        height: 100vh;
        overflow-y: auto;
        z-index: 5;
    }

    .gallery-header {
        text-align: center;
        margin-bottom: 50px;
    }

    .gallery-header h1 {
        font-family: "Cinzel", serif;
        font-size: 3.5rem;
        margin-bottom: 10px;
        color: #333;
    }

    .gallery-header .artist-title {
        font-size: 1.2rem;
        letter-spacing: 2px;
        color: #666;
    }

    .gallery-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
        gap: 30px;
    }

    .gallery-item {
        position: relative;
        aspect-ratio: 1;
        overflow: hidden;
        border-radius: 4px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        cursor: pointer;
        transition:
            transform 0.3s,
            box-shadow 0.3s;
    }

    .gallery-item:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
    }

    .gallery-item.active {
        transform: translateY(-10px) scale(1.05);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    }

    .gallery-item img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s;
    }

    .gallery-item:hover img {
        transform: scale(1.1);
    }

    .artwork-colors {
        position: absolute;
        bottom: 15px;
        left: 15px;
        display: flex;
        gap: 8px;
    }

    .color-dot {
        width: 15px;
        height: 15px;
        border-radius: 50%;
        border: 2px solid white;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }

    .immersive-view {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.95);
        z-index: 1500;
        display: flex;
        align-items: center;
        justify-content: center;
        animation: fadeIn 0.3s ease-out;
        cursor: zoom-out;
    }

    @keyframes fadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    .artwork-container {
        width: 100%;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .artwork-view {
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 100%;
        height: 100%;
        cursor: default;
    }

    .artwork-image {
        max-width: 85%;
        max-height: 85vh;
        object-fit: contain;
        border-radius: 2px;
        transition: all 0.5s ease;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
    }

    .artwork-image.color-highlight {
        filter: saturate(1.2);
    }

    .color-hotspot {
        position: absolute;
        width: 22px;
        height: 22px;
        border-radius: 50%;
        border: 2px solid white;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        cursor: pointer;
        transform-origin: center;
        animation: pulse 2s infinite alternate;
        z-index: 10;
    }

    .color-hotspot:hover {
        transform: scale(1.2);
    }

    .color-hotspot.active {
        width: 28px;
        height: 28px;
        transform: scale(1.2);
        animation: none;
    }

    .color-info {
        position: absolute;
        left: 40px;
        top: 0;
        background-color: white;
        color: #333;
        padding: 8px 12px;
        border-radius: 4px;
        font-size: 0.9rem;
        white-space: nowrap;
        display: flex;
        flex-direction: column;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }

    .color-name {
        font-weight: bold;
        margin-bottom: 4px;
    }

    .color-hex {
        font-size: 0.8rem;
        opacity: 0.8;
    }

    .artwork-info-overlay {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 30px;
        background: linear-gradient(to top, rgba(0, 0, 0, 0.7), transparent);
        color: white;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    .artwork-view:hover .artwork-info-overlay {
        opacity: 1;
    }

    .artwork-title-info {
        flex: 1;
    }

    .artwork-title-info h2 {
        font-family: "Cinzel", serif;
        font-size: 1.5rem;
        font-weight: 400;
        margin-bottom: 4px;
        letter-spacing: 1px;
    }

    .artwork-title-info p {
        font-size: 0.9rem;
        opacity: 0.8;
    }

    .artwork-nav {
        display: flex;
        align-items: center;
        gap: 15px;
        margin: 0 30px;
    }

    .artwork-nav-btn {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.15);
        border: none;
        color: white;
        font-size: 1.2rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }

    .artwork-nav-btn:hover:not(:disabled) {
        background: rgba(255, 255, 255, 0.3);
    }

    .artwork-nav-btn:disabled {
        opacity: 0.5;
        cursor: default;
    }

    .artwork-counter {
        font-size: 0.9rem;
        opacity: 0.7;
    }

    .artwork-actions {
        display: flex;
        gap: 15px;
    }

    .artwork-action-btn {
        padding: 6px 16px;
        border-radius: 20px;
        background: rgba(255, 255, 255, 0.15);
        border: none;
        color: white;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s;
        position: relative;
        overflow: hidden;
    }

    .artwork-action-btn:hover {
        background: rgba(255, 255, 255, 0.3);
    }

    .artwork-action-btn::after {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: rgba(255, 255, 255, 0.2);
        transition: transform 0.3s ease;
    }

    .artwork-action-btn:hover::after {
        transform: translateX(100%);
    }

    .add-cart-btn {
        background: rgba(255, 255, 255, 0.25);
    }

    .artwork-close {
        position: absolute;
        top: 20px;
        right: 20px;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.15);
        border: none;
        color: white;
        font-size: 1.8rem;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
    }

    .artwork-close:hover {
        background: rgba(255, 255, 255, 0.3);
    }

    .modal-panel {
        position: fixed;
        z-index: 1000;
        background: rgba(255, 255, 255, 0.97);
        backdrop-filter: blur(10px);
        border-radius: 10px;
        box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
        max-width: 90%;
        max-height: 90vh;
        overflow-y: auto;
        animation: panelFadeIn 0.5s ease-out;
    }

    .artist-panel,
    .contact-panel {
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 80%;
        max-width: 1000px;
    }

    @keyframes panelFadeIn {
        from {
            opacity: 0;
            transform: translate(-50%, -45%);
        }
        to {
            opacity: 1;
            transform: translate(-50%, -50%);
        }
    }

    .close-panel {
        position: absolute;
        top: 15px;
        right: 15px;
        background: none;
        border: none;
        font-size: 2rem;
        cursor: pointer;
        color: #333;
        z-index: 10;
        transition: transform 0.3s;
    }

    .close-panel:hover {
        transform: scale(1.2);
    }

    .minimal-panel {
        padding: 50px;
        max-height: 80vh;
        overflow-y: auto;
        -ms-overflow-style: none;
        scrollbar-width: none;
    }

    .minimal-panel::-webkit-scrollbar {
        display: none;
    }

    .panel-heading {
        font-family: "Cinzel", serif;
        font-size: 1.8rem;
        font-weight: 400;
        margin-bottom: 30px;
        color: #333;
        text-align: center;
    }

    .panel-grid {
        display: grid;
        grid-template-columns: 280px 1fr;
        gap: 50px;
        height: 100%;
    }

    .panel-sidebar {
        border-right: 1px solid #eee;
        padding-right: 40px;
    }

    .panel-sidebar .artist-portrait {
        width: 200px;
        height: 200px;
        border-radius: 2px;
        overflow: hidden;
        margin-bottom: 25px;
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    }

    .panel-sidebar .artist-portrait img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .panel-sidebar h1 {
        font-family: "Cinzel", serif;
        font-size: 1.8rem;
        font-weight: 400;
        margin-bottom: 5px;
    }

    .panel-sidebar .artist-title {
        color: #666;
        font-size: 1rem;
        margin-bottom: 20px;
    }

    .artist-palette-mini {
        display: flex;
        gap: 8px;
        margin-bottom: 30px;
    }

    .palette-chip {
        width: 32px;
        height: 8px;
        display: inline-block;
        transition:
            transform 0.3s,
            box-shadow 0.3s;
        cursor: pointer;
    }

    .palette-chip:hover {
        transform: scaleY(1.8);
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    .artist-exhibitions-mini {
        margin-bottom: 30px;
    }

    .artist-exhibitions-mini h3 {
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 12px;
        color: #999;
        font-weight: 500;
    }

    .artist-exhibitions-mini ul {
        list-style: none;
    }

    .artist-exhibitions-mini li {
        margin-bottom: 10px;
        font-size: 0.9rem;
        display: flex;
        justify-content: space-between;
        transition: transform 0.3s;
        cursor: pointer;
    }

    .artist-exhibitions-mini li:hover {
        transform: translateX(5px);
        color: var(--primary-color);
    }

    .artist-exhibitions-mini .year {
        color: #999;
        flex-shrink: 0;
        width: 50px;
    }

    .artist-exhibitions-mini .venue {
        color: #333;
    }

    .inquire-button {
        width: 100%;
        padding: 12px;
        background: none;
        border: 1px solid #ddd;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s;
        position: relative;
        overflow: hidden;
    }

    .inquire-button:hover {
        background-color: #f5f5f5;
    }

    .inquire-button::after {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.05);
        transition: transform 0.4s ease;
    }

    .inquire-button:hover::after {
        transform: translateX(100%);
    }

    .panel-main {
        overflow-y: auto;
        -ms-overflow-style: none;
        scrollbar-width: none;
    }

    .panel-main::-webkit-scrollbar {
        display: none;
    }

    .bio-content p {
        margin-bottom: 20px;
        line-height: 1.7;
        color: #444;
    }

    .bio-content blockquote {
        font-style: italic;
        color: #666;
        margin: 30px 0;
        padding: 15px 30px;
        position: relative;
        border-left: 3px solid #eee;
    }

    .contact-columns-minimal {
        display: grid;
        grid-template-columns: 3fr 2fr;
        gap: 50px;
    }

    .contact-form-minimal {
        margin-bottom: 30px;
    }

    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 25px;
    }

    .form-group-minimal {
        margin-bottom: 25px;
        flex: 1;
    }

    .form-group-minimal label {
        display: block;
        margin-bottom: 8px;
        font-size: 0.9rem;
        color: #666;
    }

    .form-group-minimal input,
    .form-group-minimal textarea {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        font-family: "Raleway", sans-serif;
        font-size: 0.95rem;
        transition: all 0.3s;
    }

    .form-group-minimal input:focus,
    .form-group-minimal textarea:focus {
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(0, 169, 157, 0.1);
    }

    .checkbox-row {
        margin-bottom: 30px;
    }

    .checkbox-label-minimal {
        display: flex;
        align-items: center;
        gap: 6px;
        cursor: pointer;
    }

    .checkbox-label-minimal span {
        font-size: 0.9rem;
        color: #666;
    }

    .submit-button-minimal {
        padding: 12px 40px;
        background-color: #333;
        color: white;
        border: none;
        font-size: 0.9rem;
        cursor: pointer;
        transition: all 0.3s;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        position: relative;
        overflow: hidden;
    }

    .submit-button-minimal:hover {
        background-color: #000;
    }

    .submit-button-minimal.submitting {
        background-color: #999;
        cursor: default;
    }

    .submit-button-minimal::after {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: rgba(255, 255, 255, 0.2);
        transition: transform 0.4s ease;
    }

    .submit-button-minimal:hover::after {
        transform: translateX(100%);
    }

    .spinner {
        width: 16px;
        height: 16px;
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        border-top-color: white;
        animation: spin 1s linear infinite;
    }

    @keyframes spin {
        to {
            transform: rotate(360deg);
        }
    }

    .contact-info-minimal {
        padding-left: 30px;
        border-left: 1px solid #eee;
    }

    .contact-method-minimal {
        margin-bottom: 30px;
    }

    .contact-label {
        display: block;
        font-size: 0.9rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: #999;
        margin-bottom: 10px;
    }

    .contact-method-minimal p {
        margin-bottom: 5px;
        color: #333;
    }

    .form-success-minimal {
        text-align: center;
        padding: 50px 0;
    }

    .form-success-minimal .success-icon {
        width: 60px;
        height: 60px;
        border-radius: 50%;
        background-color: #f5f5f5;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        font-size: 1.5rem;
        color: #333;
        animation: successPulse 2s infinite alternate;
    }

    @keyframes successPulse {
        0% {
            transform: scale(1);
            box-shadow: 0 0 0 0 rgba(0, 169, 157, 0.2);
        }
        100% {
            transform: scale(1.05);
            box-shadow: 0 0 0 10px rgba(0, 169, 157, 0);
        }
    }

    .form-success-minimal p {
        margin-bottom: 10px;
        color: #333;
    }

    .action-button-minimal {
        padding: 10px 25px;
        background: none;
        border: 1px solid #ddd;
        font-size: 0.9rem;
        cursor: pointer;
        margin-top: 20px;
        transition: all 0.3s;
        position: relative;
        overflow: hidden;
    }

    .action-button-minimal:hover {
        background-color: #f5f5f5;
    }

    .action-button-minimal::after {
        content: "";
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.05);
        transition: transform 0.4s ease;
    }

    .action-button-minimal:hover::after {
        transform: translateX(100%);
    }

    .floating-artwork {
        cursor: zoom-in;
        animation: fadeInUp 0.6s backwards;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translate(0, 20px);
        }
        to {
            opacity: 1;
        }
    }

    .floating-artwork:nth-child(1) {
        animation-delay: 0.1s;
    }
    .floating-artwork:nth-child(2) {
        animation-delay: 0.2s;
    }
    .floating-artwork:nth-child(3) {
        animation-delay: 0.3s;
    }
    .floating-artwork:nth-child(4) {
        animation-delay: 0.4s;
    }
    .floating-artwork:nth-child(5) {
        animation-delay: 0.5s;
    }
    .floating-artwork:nth-child(6) {
        animation-delay: 0.6s;
    }
    .floating-artwork:nth-child(7) {
        animation-delay: 0.7s;
    }

    .artwork-frame img {
        transition:
            filter 0.4s,
            transform 0.5s;
    }

    .artwork-frame img:hover {
        filter: brightness(1.1);
        transform: scale(1.03);
    }

    .drag-handle:hover ~ img {
        filter: brightness(0.9);
    }

    @media (max-width: 992px) {
        .artist-palette {
            overflow-x: auto;
        }

        .palette-display {
            min-width: 500px;
        }

        .gallery-header h1 {
            font-size: 2.5rem;
        }

        .artwork-info-overlay {
            flex-direction: column;
            height: auto;
            padding: 15px;
            gap: 15px;
        }

        .artwork-title-info {
            text-align: center;
        }

        .panel-grid {
            grid-template-columns: 1fr;
        }

        .panel-sidebar {
            border-right: none;
            border-bottom: 1px solid #eee;
            padding-right: 0;
            padding-bottom: 30px;
            margin-bottom: 30px;
        }

        .contact-columns-minimal {
            grid-template-columns: 1fr;
        }

        .contact-info-minimal {
            padding-left: 0;
            border-left: none;
            border-top: 1px solid #eee;
            padding-top: 30px;
            margin-top: 30px;
        }
    }

    @media (max-width: 768px) {
        .experience-controls {
            flex-wrap: wrap;
            justify-content: center;
            width: 90%;
        }

        .artist-nav {
            flex-direction: row;
            top: auto;
            bottom: 100px;
            right: 50%;
            transform: translateX(50%);
        }

        .organization-controls {
            flex-direction: row;
            bottom: 100px;
            right: 50%;
            transform: translateX(50%);
        }

        .artist-nav-button .label {
            top: -35px;
            right: auto;
            left: 50%;
            transform: translateX(-50%);
        }

        .artist-nav-button:hover .label {
            transform: translateX(-50%);
        }

        .gallery-grid {
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        }

        .artist-header {
            flex-direction: column;
            text-align: center;
        }

        .exhibition-item {
            flex-direction: column;
            gap: 5px;
        }

        .exhibition-year {
            width: auto;
        }

        .minimal-panel {
            padding: 30px;
        }
    }

    @media (max-width: 600px) {
        .loading-artist {
            font-size: 3rem;
        }

        .artwork-frame {
            width: 200px;
            height: 200px;
        }

        .gallery-grid {
            grid-template-columns: 1fr;
        }

        .contact-header h1 {
            font-size: 2rem;
        }

        .artwork-image {
            max-width: 95%;
            max-height: 75vh;
        }

        .organization-controls {
            flex-direction: row;
            bottom: 150px;
        }

        .form-row {
            flex-direction: column;
            gap: 10px;
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
</style>
