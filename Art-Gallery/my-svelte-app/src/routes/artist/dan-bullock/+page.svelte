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

<!-- Navigation Bar -->
<nav class="navbar {navDark ? 'dark' : ''}">
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
    <section class="screen contact-artist">
        <div class="contact-container">
            <h2>Contact the Artist</h2>
            <p>
                If you're interested in Dan Bullock's artwork or have inquiries,
                feel free to get in touch.
            </p>
            <form class="contact-form">
                <input type="text" placeholder="Your Name" required />
                <input type="email" placeholder="Your Email" required />
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
    }
    .basket-icon {
        font-size: 1.5rem;
        line-height: 1;
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
        background-color: #f5f5f5;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        text-align: center;
        padding: 3rem 1rem;
    }

    .contact-container {
        max-width: 800px;
        width: 100%;
    }

    .contact-container h2 {
        font-size: 2.5rem;
        margin-bottom: 1rem;
        color: #333;
    }

    .contact-container p {
        font-size: 1.25rem;
        color: #555;
        margin-bottom: 2rem;
    }

    .contact-form {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .contact-form input,
    .contact-form textarea {
        width: 100%;
        padding: 1rem;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 1rem;
        box-sizing: border-box;
    }

    .contact-form button {
        background-color: #333;
        color: #fff;
        padding: 1rem;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 1.25rem;
        transition: background-color 0.3s;
    }

    .contact-form button:hover {
        background-color: #000;
    }
</style>
