document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const contentId = urlParams.get('contentId');
    if (contentId) {
        fetchTouristDetail(contentId);
    } else {
        document.getElementById('eventTitle').textContent = 'No Event Data';
    }
});

function fetchTouristDetail(contentId) {
    const serviceKey = 'UCUykSFJjiSkmGJRU%2FJy1nz3J2G6OQkxA4d4Ph1np1muPWh%2FrzAyG0rwexLH1zImm6x2dNLkiHmYjFKNmj0qig%3D%3D'
    const url = `http://apis.data.go.kr/B551011/KorService1/detailCommon1?ServiceKey=${serviceKey}&contentTypeId=15&contentId=${contentId}&MobileOS=ETC&MobileApp=AppTest&defaultYN=Y&firstImageYN=Y&areacodeYN=Y&catcodeYN=Y&addrinfoYN=Y&mapinfoYN=Y&overviewYN=Y`;

    fetch(url)
    .then(response => response.text())
    .then(str => (new window.DOMParser()).parseFromString(str, "text/xml"))
    .then(data => {
        console.log("API response data:", data);
        const item = data.getElementsByTagName("item")[0];
        if (!item) {
            console.error('Item not found in the response');
            document.getElementById('eventTitle').textContent = 'No Event Data Available';
            return;
        }

        const title = item.getElementsByTagName("title")[0].textContent;
        const firstImage = item.getElementsByTagName("firstimage")[0]?.textContent || 'path/to/default/image.jpg';
        const addr1 = item.getElementsByTagName("addr1")[0].textContent;
        const tel = item.getElementsByTagName("tel")[0]?.textContent || 'No Telephone Information';
        const overview = item.getElementsByTagName("overview")[0].textContent;

        document.getElementById('eventTitle').textContent = title;
        document.getElementById('eventImage').src = firstImage;
        document.getElementById('eventAddress').textContent = addr1;
        document.getElementById('eventTel').textContent = tel;
        document.getElementById('eventOverview').innerHTML = overview;
    })
    .catch(error => {
        console.error('Error fetching event details:', error);
        document.getElementById('eventTitle').textContent = 'Error loading event details';
    });
}
