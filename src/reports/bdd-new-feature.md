# hw-bdd-new-feature：用 Cucumber 场景驱动“按导演找相似电影”功能

分支 `edidada/cs169-labs`（自官方 starter `276700938a777c6e3f8f99c5ef5a0f148b0a9819` 建立）。

## 原始 starter 保全说明

- 官方场景文件 `features/movies_by_director.feature`（3 个场景）、`features/step_definitions/web_steps.rb`、`features/support/env.rb` 与 starter 内容保持一致，未做修改。
- starter 本体是 Rails 4.2.10 / Ruby 2.6.6 / bundler 1.17.3 老栈（与 sandbox 课程 Codio 环境一致），CI 亦按该版本组合运行。

## 实现清单（按官方 instructions 三部分驱动）

1. **Part 1 director 字段**
   - `db/migrate/20261110000000_add_director_to_movies.rb`：`add_column :movies, :director, :string`。
   - `movies_controller.rb#movie_params` 允许 `:director`，否则强参数会剥离它。
   - `new.html.erb` / `edit.html.erb` 增加 Director 文本框（label "Director"）。
2. **Part 2 场景驱动**
   - `app/models/movie.rb#others_by_same_director`：按 director 匹配且排除自身；无 director 返回 `[]`。
   - `config/routes.rb`：`resources :movies` 内 member 路由 `get 'similar'`（`GET /movies/:id/similar`，helper `similar_movie_path`）。
   - `movies_controller.rb#similar`：无 director → `redirect_to movies_path` + `flash[:warning] = "'<title>' has no director info"`；有 director → `@director` 与 `@movies` 后渲染 `show_by_director`。
   - `show.html.erb` 增加 "Find Movies With Same Director" 链接与条件性 Director 详情行；`index.html.erb` 增加 `flash[:warning]` 的 Bootstrap `alert alert-warning` 展示块。
   - `features/support/paths.rb` 增加 details / edit / Similar Movies 页（按标题 `Movie.find_by!` 解析）映射。
   - `features/step_definitions/movies_steps.rb` 增加 step `the director of "(.*)" should be "(.*)"`（DB 断言）。
3. **补充场景**：`features/similar_director_edge.feature` 验证“该导演没有其他电影”时 Similar Movies 页正常渲染（非官方场景，官方 3 场景保持原样）。

## CI

`.github/workflows/hw.yml`：ruby 2.6.6 + bundler 1.17.3（与 `Gemfile.lock` 锁定一致）；sqlite3 1.3.11 / nokogiri 1.8.4 用系统库编译；`rails db:create db:migrate RAILS_ENV=test` 后执行 `cucumber --backtrace`，并对 `N scenarios (N passed)` / `N steps (N passed)` 汇总行断言，防止 0/0 通过。

运行记录：见下方运行编号；验收时更新本文件与 results。
