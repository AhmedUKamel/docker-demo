package org.ahmedukamel.staticdemo;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BlogRepository extends JpaRepository<StaticDemoApplication.Blog, Integer> {
}