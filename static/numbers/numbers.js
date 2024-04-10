function scrollSpy(sectionSelector, activeClass) {
    addEventListener("load", (event) => {
        const sections = document.querySelectorAll(sectionSelector);
        const toc = document.querySelector("#TableOfContents");

        function onScroll() {
            toc.querySelectorAll("." + activeClass).forEach(t => t.classList.remove(activeClass))
            for (let t = sections.length - 1; t >= 0; t--) {
                const section = sections[t];
                const r = (document.documentElement.scrollTop || document.body.scrollTop) + (window.innerHeight  / 4);
                if (section.offsetTop <= r) {
                    const id = section.getAttribute("id");
                    const tocItem = toc.querySelector(`[href="#${id}"]`);
                    tocItem.classList.add(activeClass);
                    tocItem.scrollIntoView({block: "nearest", inline: "nearest"});
                    break;
                }
            }
        }

        window.addEventListener("scroll", () => {
            onScroll();
        });

        onScroll();
    });
}

scrollSpy("h2", "toc-h2-active");
scrollSpy("h3", "toc-h3-active");
