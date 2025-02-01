// script.js
document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('form');
    const gallery = document.getElementById('gallery');

    // Fetch and display photos when the page loads
    fetchPhotos();

    // Handle photo upload
    form.addEventListener('submit', async (event) => {
        event.preventDefault();

        const formData = new FormData(form);
        const response = await fetch('/upload', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            alert('Photo uploaded successfully!');
            form.reset();
            fetchPhotos(); // Refresh the gallery
        } else {
            alert('Failed to upload photo.');
        }
    });

    // Function to fetch and display photos
    async function fetchPhotos() {
        const response = await fetch('/photos');
        const photos = await response.json();

        gallery.innerHTML = ''; // Clear the gallery
        photos.forEach(photo => {
            const img = document.createElement('img');
            img.src = photo.url;
            img.alt = photo.caption;
            gallery.appendChild(img);
        });
    }
});
