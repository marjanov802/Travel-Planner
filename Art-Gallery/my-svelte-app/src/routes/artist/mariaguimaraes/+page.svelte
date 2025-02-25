<!-- Navbar.svelte -->
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
</style>
