import "../curation-pipeline/src/index.css";

import { HashRouter, Routes, Route } from "react-router-dom";
import Layout from "./pages/Layout";
import HomePage from "./pages/HomePage";
import SearchPage from "./pages/Search/SearchPage";
import ProtectedRoute from "./components/ProtectedRoute";
import { useUser } from "@/contexts/UserContext";
import "../curation-pipeline/src/index.css";
import CurationPipelineApp from "../curation-pipeline/src/App.jsx";
import { CurationProvider } from "../curation-pipeline/src/context/CurationContext"; 
import DetailedView from "./components/uniprod-tf-queries/detail/DetailedView.jsx";

function AppRoutes() {
  const { userStatus } = useUser();
  return (
    <HashRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<HomePage />} />
          <Route path="Search/:step?" element={<SearchPage />} />
          <Route
          path="curation-pipeline/*"
          element={
            <CurationProvider>
              <CurationPipelineApp />
            </CurationProvider>
            }
          />
        </Route>
      </Routes>
    </HashRouter>
  );
}

export default AppRoutes;
