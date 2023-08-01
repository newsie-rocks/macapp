//
//  HtmlStringView.swift
//  xos
//
//  Created by nick on 01/08/2023.
//

import SwiftUI
import WebKit

#if os(iOS)
struct HTMLView: UIViewRepresentable {
    let htmlContent: String

    init(_ htmlContent: String) {
        self.htmlContent = htmlContent
    }

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
#endif

#if os(iOS)
struct HtmlView_Previews: PreviewProvider {
    // swiftlint:disable line_length
    static var htmlContent = """
        <style>
            body {

                color: red;
            }
        </style>
          \n<img src=\"https://spectrum.ieee.org/media-library/image.webp?id=34710692&width=980\"/><br/><br/><p>The annual IEEE election process begins this month, so be sure to check your mailbox then for your ballot. To help you choose the 2024 IEEE president-elect, <em>The Institute</em> is publishing the official biographies and position statements of the two candidates, as approved by the IEEE Board of Directors. The candidates are Senior Member <a href=\"https://candidates.ieee.org/candidates/nominees/kathleen-a-kramer/\" rel=\"noopener noreferrer\" target=\"_blank\">Kathleen Kramer</a> and Life Fellow <a href=\"https://candidates.ieee.org/candidates/nominees/roger-u-fujii/\" rel=\"noopener noreferrer\" target=\"_blank\">Roger Fujii</a>.</p><h2>Senior Member Kathleen Kramer</h2><p class=\"shortcode-media shortcode-media-rebelmouse-image rm-resized-container rm-resized-container-25 rm-float-left\" data-rm-resized-container=\"25%\" style=\"float: left;\">\n<img alt=\"Photo of a smiling woman in a blue jacket.  \" class=\"rm-shortcode rm-resized-image\" data-rm-shortcode-id=\"9a5fcef8f07754829379e051af0a1d42\" data-rm-shortcode-name=\"rebelmouse-image\" id=\"d9fbf\" loading=\"lazy\" src=\"https://spectrum.ieee.org/media-library/photo-of-a-smiling-woman-in-a-blue-jacket.jpg?id=32895700&width=980\" style=\"max-width: 100%\"/>\n<small class=\"image-media media-photo-credit\" placeholder=\"Add Photo Credit...\" style=\"max-width: 100%;\">\n            JT MacMillan\n        </small>\n</p><p>Nominated by the IEEE Board of Directors</p><p>Kramer is a professor of electrical engineering at the University of San Diego, where she served as director of engineering from 2004 to 2013. As director she provided academic leadership over its engineering programs.</p><p>She was a member of the technical staff at several companies including Bell Communications Research, Hewlett-Packard, and Viasat.</p><p>Kramer is the past vice president of the IEEE Aerospace and Electronic Systems Society and is a distinguished lecturer for the society.</p><p>She has emphasized collaboration when serving in various high-level IEEE leadership roles such as IEEE secretary, director of IEEE Region 6, and chair of governance and of the IEEE ad hoc committee on innovating funding models. In these positions she contributed to advancing IEEE’s mission across a wide spectrum of activities and technical communities.</p><p>Kramer earned bachelor’s degrees in electrical engineering and physics from Loyola Marymount University, in Los Angeles. She earned master’s and doctoral degrees in EE from Caltech.</p><h2>Candidate statement</h2><p>I offer transformational leadership for a better IEEE. I approach the responsibilities of this role with respect for the challenges, and an awareness of the opportunity the President-Elect is entrusted with to transform IEEE. I have proven myself to be a collaborative leader in every leadership position I’ve held. My most significant accomplishments have stemmed from sincerely valuing and including different interests and perspectives, and teaming towards strategic goals that allow the whole to become greater than the sum of the parts. If elected, I will continue to see one IEEE whose commitment to technical excellence and expertise provides the inspiration and engagement based in its people and their technical activities. I am grateful for each of my leadership roles within and on behalf of the IEEE – as each has brought with it the opportunity to partner across the IEEE, working with inspirational and effective leaders and volunteers, to contribute together to advance technology. I commit to these five priorities: </p><ul><li>Inspire and engage the next generation of IEEE, especially WIE (Women in Engineering), Young Professionals, and Students </li><li>Include our global and diverse membership, effectively and equitably, to better advance technology </li><li>Collaborate as a community on our transformational public imperatives- education, policy, history, community, and humanitarian technologies. </li><li>Improve the effectiveness and efficiency of the IEEE while honoring our obligations to the membership </li><li>Empower the success of our technical communities, global and local, to share and foster technical knowledge and enhance our professional lives</li></ul><h2>Life Fellow Roger Fujii</h2><p class=\"shortcode-media shortcode-media-rebelmouse-image rm-resized-container rm-resized-container-25 rm-float-left\" data-rm-resized-container=\"25%\" style=\"float: left;\">\n<img alt=\"Photo of a smiling man in a suit in tie.\" class=\"rm-shortcode rm-resized-image\" data-rm-shortcode-id=\"2b288d9648f53bcf9cb8483ade81197b\" data-rm-shortcode-name=\"rebelmouse-image\" id=\"48864\" loading=\"lazy\" src=\"https://spectrum.ieee.org/media-library/photo-of-a-smiling-man-in-a-suit-in-tie.jpg?id=32895812&width=980\" style=\"max-width: 100%\"/>\n<small class=\"image-media media-photo-credit\" placeholder=\"Add Photo Credit...\" style=\"max-width: 100%;\">\n            Joey Ikemoto\n        </small>\n</p><p>Nominated by the IEEE Board of Directors</p><p>Fujii is president of Fujii Systems in Rancho Palos Verdes, Calif., which designs critical systems. Before starting his company, Fujii was vice president at Northrop Grumman’s engineering division in San Diego (US $1.086 billion).</p><p> His area of expertise is certifying critical systems. He has been a guest lecturer at California State University, the University of California, and Xiamen University.</p><p>An active IEEE volunteer, Fujii most recently chaired the IEEE financial transparency reporting committee and the IEEE ad hoc committee on IEEE in 2050 and Beyond. The ad hoc committee envisioned scenarios to gain a global perspective of what the world might look like in 2050 and beyond,and what these potential futures might mean for IEEE.</p><p>He was 2016 president of the IEEE Computer Society, 2021 vice president of the IEEE Technical Activities Board, and 2012–2014 director of Division VIII.</p><p>Fujii received the 2020 Richard E. Merwin Award, the IEEE Computer Society’s highest-level volunteer service award.</p><h2>Candidate statement</h2><p>At the front of our acute global challenges, IEEE has the unique opportunity to contribute technical leadership and innovations toward lasting solutions. To seize it, we need to develop our organization to be more responsive in serving our community and resilient in an increasingly uncertain operating environment. To this end, as President, I will pursue a strategy to transform IEEE with the following objectives:</p><ul><li>A proactive, inclusive community that uses technology for the good of others. We will continue to increase our membership and its diversity. We will expand collaborations with industry, government, students, and others who strive to use technology to make the world better.</li><li>Provide sustainable solutions to the world. Working with a more inclusive community gives us more influence and brain trust to innovate for the world’s systemic challenges - climate change, reliable food sources, accessible health care, clean environments, and sustainable energy sources.</li><li>Deliver more quantifiable value to our members. We will engage more members and invest IEEE funds to develop products and services that deliver real, differentiated value. Our products and services must be more relevant and useful to our entire community of volunteers and members.</li><li>Build a resilient organization. For IEEE to last in any operating environment, we will establish the processes and governance to operate efficiently and continually evolve our organization. We must include emerging multi-disciplinary communities and the members in growing global regions.</li></ul>
    """
    // swiftlint:enable line_length

    static var previews: some View {
        HTMLView(htmlContent)
    }
}
#endif
