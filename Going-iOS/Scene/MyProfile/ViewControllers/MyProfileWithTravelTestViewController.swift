extension MyProfileWithTravelTestViewController: TestResultViewDelegate {
    func backToTestButton() {
        let vc = UserTestSplashViewController()
        self.navigationController?.pushViewController(vc, animated: false)
        vc.beforeVC = "myProfile"
    }
}
